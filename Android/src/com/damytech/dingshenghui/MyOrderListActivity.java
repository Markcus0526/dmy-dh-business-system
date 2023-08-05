package com.damytech.dingshenghui;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.format.DateUtils;
import android.view.*;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STGoodStatusItem;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.PullRefreshListView.PullToRefreshBase;
import com.damytech.utils.PullRefreshListView.PullToRefreshListView;
import com.damytech.utils.ResolutionSet;
import com.damytech.utils.SmartImageView.SmartImageView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;

public class MyOrderListActivity extends SuperActivity implements DialogInterface.OnDismissListener {
    final int MODE_PAYED = 0;
    final int MODE_PAY = 1;
    final int MODE_REJECT = 2;
    int nMode = MODE_PAYED;
    int nPageNo = 0;

    RelativeLayout mainLayout;
    boolean bInitialized = false;

    ImageView imgBack;

    TextView lblPayed = null;
    TextView lblPay = null;
    TextView lblReject = null;

    boolean bExistNext = true;
    PullToRefreshListView mGoodList;
    ListView mRealListView;
    GoodListDataAdapter mAdapter;
    ArrayList<STGoodStatusItem> arrGood = new ArrayList<STGoodStatusItem>();
    JsonHttpResponseHandler handler = null;

    DeleteDialog dlg = null;

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            switch (v.getId())
            {
                case R.id.imgBack:
                    finish();
                    break;
                case R.id.lblPayed:
                    if (nMode == MODE_PAYED) return;
                    nMode = MODE_PAYED;
                    lblPayed.setBackgroundResource(R.drawable.rectblueblue);
                    lblPayed.setTextColor(getResources().getColor(R.color.white));
                    lblPay.setBackgroundResource(R.drawable.rectbluewhite);
                    lblPay.setTextColor(getResources().getColor(R.color.bluelight));
                    lblReject.setBackgroundResource(R.drawable.rectbluewhite);
                    lblReject.setTextColor(getResources().getColor(R.color.bluelight));

                    nPageNo = 0;
                    arrGood.clear();
                    startProgress();
                    CommManager.GetMyOrderList(GlobalData.GetUserID(MyOrderListActivity.this), nMode, nPageNo, handler);
                    break;
                case R.id.lblPay:
                    if (nMode == MODE_PAY) return;
                    nMode = MODE_PAY;
                    lblPayed.setBackgroundResource(R.drawable.rectbluewhite);
                    lblPayed.setTextColor(getResources().getColor(R.color.bluelight));
                    lblPay.setBackgroundResource(R.drawable.rectblueblue);
                    lblPay.setTextColor(getResources().getColor(R.color.white));
                    lblReject.setBackgroundResource(R.drawable.rectbluewhite);
                    lblReject.setTextColor(getResources().getColor(R.color.bluelight));

                    nPageNo = 0;
                    arrGood.clear();
                    startProgress();
                    CommManager.GetMyOrderList(GlobalData.GetUserID(MyOrderListActivity.this), nMode, nPageNo, handler);
                    break;
                case R.id.lblReject:
                    if (nMode == MODE_REJECT) return;
                    nMode = MODE_REJECT;
                    lblPayed.setBackgroundResource(R.drawable.rectbluewhite);
                    lblPayed.setTextColor(getResources().getColor(R.color.bluelight));
                    lblPay.setBackgroundResource(R.drawable.rectbluewhite);
                    lblPay.setTextColor(getResources().getColor(R.color.bluelight));
                    lblReject.setBackgroundResource(R.drawable.rectblueblue);
                    lblReject.setTextColor(getResources().getColor(R.color.white));

                    nPageNo = 0;
                    arrGood.clear();
                    startProgress();
                    CommManager.GetMyOrderList(GlobalData.GetUserID(MyOrderListActivity.this), nMode, nPageNo, handler);
                    break;
            }
        }
    };

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_myorderlist);

        mainLayout = (RelativeLayout)findViewById(R.id.parent_layout);
        mainLayout.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    public void onGlobalLayout() {
                        if (bInitialized == false)
                        {
                            Rect r = new Rect();
                            mainLayout.getLocalVisibleRect(r);
                            ResolutionSet._instance.setResolution(r.width(), r.height());
                            ResolutionSet._instance.iterateChild(findViewById(R.id.parent_layout));
                            bInitialized = true;
                        }
                    }
                }
        );

        initControl();
        initHandler();
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        lblPayed = (TextView) findViewById(R.id.lblPayed);
        lblPayed.setOnClickListener(onClickListener);
        lblPay = (TextView) findViewById(R.id.lblPay);
        lblPay.setOnClickListener(onClickListener);
        lblReject = (TextView) findViewById(R.id.lblReject);
        lblReject.setOnClickListener(onClickListener);

        mGoodList = (PullToRefreshListView) findViewById(R.id.viewData);
        mGoodList.setMode(PullToRefreshBase.Mode.PULL_FROM_END);

        arrGood.clear();
        mGoodList.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener<ListView>() {
            @Override
            public void onRefresh(PullToRefreshBase<ListView> refreshView) {
                String label = DateUtils.formatDateTime(getApplicationContext(), System.currentTimeMillis(),
                        DateUtils.FORMAT_SHOW_TIME | DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_ABBREV_ALL);
                refreshView.getLoadingLayoutProxy().setLastUpdatedLabel(label);
                nPageNo = nPageNo + 1;

                CommManager.GetMyOrderList(GlobalData.GetUserID(MyOrderListActivity.this), nMode, nPageNo, handler);
            }
        });

        mGoodList.setOnLastItemVisibleListener( new PullToRefreshBase.OnLastItemVisibleListener() {
            @Override
            public void onLastItemVisible() {}
        });

        mRealListView = mGoodList.getRefreshableView();

        return;
    }

    private void initHandler()
    {
        handler = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                mGoodList.onRefreshComplete();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    String strPath = jsonData.getString("BASEURL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        JSONArray jsonArray = jsonData.getJSONArray("RETDATA");
                        for (int i = 0; i < jsonArray.length(); i++)
                        {
                            STGoodStatusItem item = STGoodStatusItem.decode(jsonArray.getJSONObject(i));
                            item.imgpath = strPath + item.imgpath;
                            arrGood.add(item);
                        }

                        if (arrGood == null)
                        {
                            return;
                        }

                        showGoods();

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(MyOrderListActivity.this, getString(R.string.fuwuqineibucuowu));
                        finish();
                    }
                }
                catch (Exception ex)
                {
                    ex.printStackTrace();
                };
            }

            @Override
            public void onFailure(Throwable error, String content) {
                super.onFailure(error, content);
                GlobalData.showToast(MyOrderListActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

        return;
    }

    @Override
    public void onResume()
    {
        super.onResume();

        nPageNo = 0;
        arrGood.clear();
        startProgress();
        CommManager.GetMyOrderList(GlobalData.GetUserID(MyOrderListActivity.this), nMode, nPageNo, handler);
    }

    @Override
    public void onStop()
    {
        super.onStop();

        if (dlg != null && dlg.isShowing())
            dlg.dismiss();
    }

    private void showGoods()
    {
        if (arrGood.size() % ConstData.GOODITEM_COUNT == 0)
        {
            bExistNext = true;
            mGoodList.setMode(PullToRefreshBase.Mode.PULL_FROM_END);
        }
        else
        {
            bExistNext = false;
            mGoodList.setMode(PullToRefreshBase.Mode.DISABLED);
        }

        if (mRealListView != null)
        {
            mRealListView.setCacheColorHint(Color.parseColor("#FFF1F1F1"));
            mRealListView.setDivider(new ColorDrawable(getResources().getColor(R.color.gray)));
            mRealListView.setDividerHeight(1);

            mAdapter = new GoodListDataAdapter(MyOrderListActivity.this, 0, arrGood);
            mRealListView.setAdapter(mAdapter);
        }

        return;
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        if (dialog.getClass() == WheelDatePickerDlg.class)
        {
        }
    }

    private class GoodListDataAdapter extends ArrayAdapter<STGoodStatusItem>
    {
        ArrayList<STGoodStatusItem> list;
        Context ctx;

        public GoodListDataAdapter(Context ctx, int resourceId, ArrayList<STGoodStatusItem> list) {
            super(ctx, resourceId, list);
            this.ctx = ctx;
            this.list = list;
        }

        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View v = convertView;
            if (v == null)
            {
                LayoutInflater inflater = (LayoutInflater)ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                v = inflater.inflate(R.layout.view_myorderitem, null);
                ResolutionSet._instance.iterateChild(v.findViewById(R.id.parent_layout));
            }

            TextView lblBuyDate = (TextView) v.findViewById(R.id.lblBuyDate);
            lblBuyDate.setText(list.get(position).buydate);
            TextView lblPrice = (TextView) v.findViewById(R.id.lblPrice);
            lblPrice.setText(list.get(position).price + getString(R.string.yuan));

            SmartImageView image = (SmartImageView) v.findViewById(R.id.viewPhoto);
            image.setImageUrl(list.get(position).imgpath, R.drawable.mainicon);
            TextView lblTitle = (TextView) v.findViewById(R.id.lblTitle);
            lblTitle.setText(list.get(position).goodname);
            TextView lblContent = (TextView) v.findViewById(R.id.lblData);
            lblContent.setText(list.get(position).gooddesc);
            TextView lblStatus = (TextView)v.findViewById(R.id.lblStatus);
            Button btnGo = (Button) v.findViewById(R.id.btnGo);
            if (nMode == MODE_PAYED)
            {
                if (list.get(position).evalstatus == ConstData.NOTEVALUTE_MODE)
                {
                    lblStatus.setText(getString(R.string.deipingjia));
                    btnGo.setText(getString(R.string.deipingjia));
                    btnGo.setBackgroundColor(getResources().getColor(R.color.orange));
                }
                else if (list.get(position).evalstatus == ConstData.EVALUTED_MODE)
                {
                    lblStatus.setText(getString(R.string.yipingjia));
                    btnGo.setText(getString(R.string.yipingjia));
                    btnGo.setBackgroundColor(getResources().getColor(R.color.bluelight_disable));
                    btnGo.setEnabled(false);
                }
            }
            else if (nMode == MODE_PAY)
            {
                btnGo.setText(getString(R.string.qufukuan));
                btnGo.setBackgroundColor(getResources().getColor(R.color.orange));
            }
            else
            {
                btnGo.setText(getString(R.string.tuihuo));
                btnGo.setBackgroundColor(getResources().getColor(R.color.orange));
            }
            btnGo.setTag(0xFFFFFFF0, nMode);
            btnGo.setTag(0xFFFFFFF1, list.get(position).goodid);
            btnGo.setTag(0xFFFFFFF2, list.get(position).saleid);
            btnGo.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Integer mode = (Integer)v.getTag(0xFFFFFFF0);
                    Long goodid = (Long) v.getTag(0xFFFFFFF1);
                    Long saleid = (Long) v.getTag(0xFFFFFFF2);

                    int modeVal = mode.intValue();
                    long goodidVal = goodid.longValue();
                    long saleidVal = saleid.longValue();

                    if (modeVal == MODE_PAYED)
                    {
                        Intent intent = new Intent(MyOrderListActivity.this, EvaluteActivity.class);
                        intent.putExtra("GOODID", goodidVal);
                        intent.putExtra("SALEID", saleidVal);
                        startActivity(intent);
                    }

                    if (modeVal == MODE_REJECT)
                    {
                        dlg = new DeleteDialog(MyOrderListActivity.this);
                        dlg.setOnDismissListener(MyOrderListActivity.this);
                        dlg.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                        dlg.show();
                    }
                }
            });

            return v;
        }
    }

    public class DeleteDialog extends Dialog
    {
        Context mContext;
        Button btnOk;
        Button btnCancel;
        OnDismissListener dismissListener = null;

        int nRes = 0;

        public DeleteDialog(Context context)
        {
            super(context);
            mContext = context;
        }

        @Override
        public void onCreate(Bundle savedInstanceState)
        {
            super.onCreate(savedInstanceState);
            requestWindowFeature(Window.FEATURE_NO_TITLE);
            setContentView(R.layout.dlg_confirm);

            ResolutionSet._instance.iterateChild(((RelativeLayout)findViewById(R.id.parent_layout)).getChildAt(0));

            initControl();
        }

        private void initControl()
        {
            btnOk = (Button) findViewById(R.id.btnOk);
            btnOk.setOnClickListener(onClickListener);
            btnCancel = (Button) findViewById(R.id.btnCancel);
            btnCancel.setOnClickListener(onClickListener);
        }

        View.OnClickListener onClickListener = new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                switch (v.getId())
                {
                    case R.id.btnOk:
                        nRes = 1;
                        dismissListener.onDismiss(DeleteDialog.this);
                        dismiss();
                        break;
                    case R.id.btnCancel:
                        nRes = 0;
                        DeleteDialog.this.dismiss();
                        break;
                }
            }
        };

        public void setOnDismissListener(OnDismissListener listener)
        {
            dismissListener = listener;
        }

        public int IsDeleted()
        {
            return nRes;
        }
    }
}
