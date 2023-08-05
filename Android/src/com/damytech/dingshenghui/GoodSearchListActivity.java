package com.damytech.dingshenghui;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.SpannableString;
import android.text.TextWatcher;
import android.text.format.DateUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STGoodItem;
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

public class GoodSearchListActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    long nKindID = 0;
    final int MODE_SPEC = 0;
    final int MODE_NORMAL = 1;
    final int MODE_CAR = 2;
    int nMode = MODE_SPEC;
    int nPageNo = 0;
    String strSearch = "";

    ImageView imgBack = null;
    ImageView imgUserInfo = null;
    ImageView imgSearch = null;

    TextView lblDelete = null;

    EditText txtSearch = null;

    boolean bExistNext = true;
    PullToRefreshListView mGoodList;
    ListView mRealListView;
    GoodListDataAdapter mAdapter;
    ArrayList<STGoodItem> arrGood = new ArrayList<STGoodItem>();
    JsonHttpResponseHandler handlerGoodList = null;

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
                case R.id.imgUserInfo:
                    Intent intentUserInfo = new Intent(GoodSearchListActivity.this, UserInfoActivity.class);
                    startActivity(intentUserInfo);
                    break;
                case R.id.imgSearch:
                    arrGood.clear();
                    nPageNo = 0;

                    strSearch = txtSearch.getText().toString();

                    startProgress();
                    CommManager.FindGoodsList(nMode, nKindID, strSearch, nPageNo, handlerGoodList);
                    break;
                case R.id.lblDelete:
                    txtSearch.setText("");
                    break;
            }
        }
    };

    TextWatcher textWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {}
        @Override
        public void afterTextChanged(Editable s)
        {
            String strSearch = s.toString();

            if (strSearch.length() == 0)
            {
                lblDelete.setVisibility(View.INVISIBLE);
            }
            else
            {
                lblDelete.setVisibility(View.VISIBLE);
            }
        }
    };

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_goodsearchlist);

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

        nMode = getIntent().getIntExtra("MODE", MODE_SPEC);
        nKindID = getIntent().getLongExtra("KIND", 0);

        initControl();
        initHandler();
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);
        imgUserInfo = (ImageView) findViewById(R.id.imgUserInfo);
        imgUserInfo.setOnClickListener(onClickListener);
        imgSearch = (ImageView) findViewById(R.id.imgSearch);
        imgSearch.setOnClickListener(onClickListener);

        lblDelete = (TextView) findViewById(R.id.lblDelete);
        lblDelete.setOnClickListener(onClickListener);

        txtSearch = (EditText) findViewById(R.id.txtSearch);
        txtSearch.addTextChangedListener(textWatcher);

        mGoodList = (PullToRefreshListView) findViewById(R.id.listGoods);
        mGoodList.setMode(PullToRefreshBase.Mode.PULL_FROM_END);

        arrGood.clear();
        mGoodList.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener<ListView>() {
            @Override
            public void onRefresh(PullToRefreshBase<ListView> refreshView) {
                String label = DateUtils.formatDateTime(getApplicationContext(), System.currentTimeMillis(),
                        DateUtils.FORMAT_SHOW_TIME | DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_ABBREV_ALL);
                refreshView.getLoadingLayoutProxy().setLastUpdatedLabel(label);
                nPageNo = nPageNo + 1;

                CommManager.FindGoodsList(nMode, nKindID, strSearch, nPageNo, handlerGoodList);
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
        handlerGoodList = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                mGoodList.onRefreshComplete();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        JSONArray jsonArray = jsonData.getJSONArray("RETDATA");
                        String basePath = jsonData.getString("BASEURL");
                        for (int i = 0; i < jsonArray.length(); i++)
                        {
                            STGoodItem item = STGoodItem.decode(jsonArray.getJSONObject(i));
                            item.imgpath = basePath + item.imgpath;
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
                        GlobalData.showToast(GoodSearchListActivity.this, getString(R.string.fuwuqineibucuowu));
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
                GlobalData.showToast(GoodSearchListActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

        return;
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

            mAdapter = new GoodListDataAdapter(GoodSearchListActivity.this, 0, arrGood);
            mRealListView.setAdapter(mAdapter);
        }

        return;
    }

    private class GoodListDataAdapter extends ArrayAdapter<STGoodItem>
    {
        ArrayList<STGoodItem> list;
        Context ctx;

        public GoodListDataAdapter(Context ctx, int resourceId, ArrayList<STGoodItem> list) {
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
                v = inflater.inflate(R.layout.view_gooditem, null);
                ResolutionSet._instance.iterateChild(v.findViewById(R.id.parent_layout));
            }

            SmartImageView image = (SmartImageView) v.findViewById(R.id.viewPhoto);
            image.setImageUrl(list.get(position).imgpath, R.drawable.mainicon);
            TextView lblTitle = (TextView) v.findViewById(R.id.lblTitle);
            lblTitle.setText(list.get(position).name);
            TextView lblContent = (TextView) v.findViewById(R.id.lblData);
            lblContent.setText(list.get(position).noti);
            TextView lblPrice = (TextView)v.findViewById(R.id.lblPrice);
            String strText = list.get(position).price + getString(R.string.yuan);
            SpannableString ss = new SpannableString(strText);
            ss.setSpan(new ForegroundColorSpan(getResources().getColor(R.color.bluelight)), 0, strText.length()-1, 0);
            lblPrice.setText(ss);

            TextView lblSelledCount = (TextView) v.findViewById(R.id.lblSelledCount);
            lblSelledCount.setText(getString(R.string.yishou) + list.get(position).selledcount);

            v.setTag(list.get(position).uid);
            v.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Long uid = (Long) v.getTag();
                    long nUID = uid.longValue();

                    Intent intent = new Intent(GoodSearchListActivity.this, GoodDetailActivity.class);
                    intent.putExtra("GOODID", nUID);
                    startActivity(intent);
                }
            });

            return v;
        }
    }
}
