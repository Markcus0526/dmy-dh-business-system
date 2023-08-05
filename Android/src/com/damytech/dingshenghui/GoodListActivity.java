package com.damytech.dingshenghui;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.format.DateUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STGoodItem;
import com.damytech.dataclasses.STGoodKindItem;
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

public class GoodListActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    final int MODE_SPEC = 0;
    final int MODE_NORMAL = 1;
    final int MODE_CAR = 2;
    int nMode = MODE_SPEC;
    int nPageNo = 0;
    long nKindID = 0;

    boolean bExistNext = true;
    PullToRefreshListView mGoodList;
    ListView mRealListView;
    GoodListDataAdapter mAdapter;

    ImageView imgBack = null;
    ImageView imgUserInfo = null;
    ImageView imgSearch = null;

    TextView lblTitle = null;

    RelativeLayout rlMenu = null;
    LinearLayout llKinds = null;

    ArrayList<STGoodKindItem> arrKind = new ArrayList<STGoodKindItem>();
    JsonHttpResponseHandler handlerKindList = null;
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
                    Intent intentUserInfo = new Intent(GoodListActivity.this, UserInfoActivity.class);
                    startActivity(intentUserInfo);
                    break;
                case R.id.imgSearch:
                    Intent intentSearch = new Intent(GoodListActivity.this, GoodSearchListActivity.class);
                    intentSearch.putExtra("MODE", nMode);
                    intentSearch.putExtra("KIND", nKindID);
                    startActivity(intentSearch);
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
        setContentView(R.layout.activity_goodlist);

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

        initControl();
        initHandler();

        switch (nMode)
        {
            case MODE_NORMAL:
                lblTitle.setText(getString(R.string.jingcaituangou));
                rlMenu.setVisibility(View.VISIBLE);
                break;
            case MODE_CAR:
                lblTitle.setText(getString(R.string.wangshangchecheng));
                rlMenu.setVisibility(View.GONE);
                break;
            case MODE_SPEC:
                lblTitle.setText(getString(R.string.tehuishanghu));
                rlMenu.setVisibility(View.VISIBLE);
                break;
        }

        if (nMode != MODE_CAR)
        {
            startProgress();
            CommManager.GetGoodKindList(handlerKindList);
        }
        else
        {
            nPageNo = 0;
            nKindID = ConstData.KIND_CAR_ID;
            startProgress();
            CommManager.GetGoodsList(nMode, nKindID, nPageNo, handlerGoodList);
        }
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);
        imgUserInfo = (ImageView) findViewById(R.id.imgUserInfo);
        imgUserInfo.setOnClickListener(onClickListener);
        imgSearch = (ImageView) findViewById(R.id.imgSearch);
        imgSearch.setOnClickListener(onClickListener);

        lblTitle = (TextView) findViewById(R.id.lblTitle);

        rlMenu = (RelativeLayout) findViewById(R.id.rlMenu);
        llKinds = (LinearLayout) findViewById(R.id.llKinds);

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

                CommManager.GetGoodsList(nMode, nKindID, nPageNo, handlerGoodList);
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
        handlerKindList = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        JSONArray jsonArray = jsonData.getJSONArray("RETDATA");
                        String basePath = jsonData.getString("BASEURL");
                        for (int i = 0; i < jsonArray.length(); i++)
                        {
                            STGoodKindItem item = STGoodKindItem.decode(jsonArray.getJSONObject(i));
                            item.imgpath = basePath + item.imgpath;
                            arrKind.add(item);
                        }

                        if (arrKind == null || arrKind.size() == 0)
                        {
                            stopProgress();
                            return;
                        }

                        showKindItems();

                        nPageNo = 0;
                        nKindID = arrKind.get(0).uid;
                        CommManager.GetGoodsList(nMode, nKindID, nPageNo, handlerGoodList);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(GoodListActivity.this, getString(R.string.fuwuqineibucuowu));
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
                GlobalData.showToast(GoodListActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

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
                        GlobalData.showToast(GoodListActivity.this, getString(R.string.fuwuqineibucuowu));
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
                GlobalData.showToast(GoodListActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

        return;
    }

    private void showKindItems()
    {
        for (int i = 0; i < arrKind.size(); i++)
        {
            LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View v = inflater.inflate(R.layout.view_goodkinditem, null);

            TextView lblName = (TextView) v.findViewById(R.id.lblName);
            lblName.setText(arrKind.get(i).title);
            SmartImageView imgIcon = (SmartImageView) v.findViewById(R.id.viewIcon);
            imgIcon.setImageUrl(arrKind.get(i).imgpath, R.drawable.mainicon);

            v.setTag(arrKind.get(i).uid);
            v.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Long kindid = (Long)v.getTag();
                    nKindID = kindid.longValue();

                    arrGood.clear();
                    nPageNo = 0;

                    startProgress();
                    CommManager.GetGoodsList(nMode, nKindID, nPageNo, handlerGoodList);
                }
            });

            llKinds.addView(v);
        }

        ResolutionSet._instance.iterateChild(llKinds);

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

            mAdapter = new GoodListDataAdapter(GoodListActivity.this, 0, arrGood);
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

                    Intent intent = new Intent(GoodListActivity.this, GoodDetailActivity.class);
                    intent.putExtra("GOODID", nUID);
                    startActivity(intent);
                }
            });

            return v;
        }
    }
}
