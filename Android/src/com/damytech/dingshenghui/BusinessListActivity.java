package com.damytech.dingshenghui;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STServiceItem;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ResolutionSet;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

public class BusinessListActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    final int MODE_BANK = 0;
    final int MODE_CREDIT = 1;
    final int MODE_INSURANCE = 2;
    final int MODE_PROPERTY = 3;
    final int MODE_SMALLMONEY = 4;
    int nMode = MODE_BANK;

    ImageView imgBack;
    TextView lblTitle;
    ListView listData;

    ItemAdapter mAdapter;
    ArrayList<STServiceItem> arrData = new ArrayList<STServiceItem>();
    JsonHttpResponseHandler handlerServiceList = null;

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
                case R.id.btnOk:
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
        setContentView(R.layout.activity_businesslist);

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

        nMode = getIntent().getIntExtra("MODE", MODE_BANK);
        switch (nMode)
        {
            case MODE_BANK:
                lblTitle.setText(getString(R.string.yinhangkashouli));
                break;
            case MODE_CREDIT:
                lblTitle.setText(getString(R.string.xinyongkabanli));
                break;
            case MODE_INSURANCE:
                lblTitle.setText(getString(R.string.baoxianyewu));
                break;
            case MODE_PROPERTY:
                lblTitle.setText(getString(R.string.licaichanpin));
                break;
            case MODE_SMALLMONEY:
                lblTitle.setText(getString(R.string.xiaoedaikuan));
                break;
        }

        startProgress();
        CommManager.GetServiceList(nMode, handlerServiceList);
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        lblTitle = (TextView) findViewById(R.id.lblTitle);

        listData = (ListView) findViewById(R.id.listData);

        return;
    }

    private void initHandler()
    {
        handlerServiceList = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        JSONArray jsonArray = jsonData.getJSONArray("RETDATA");
                        for (int i = 0; i < jsonArray.length(); i++)
                        {
                            STServiceItem item = STServiceItem.decode(jsonArray.getJSONObject(i));
                            arrData.add(item);

                            if (arrData == null || arrData.size() == 0)
                                return;

                            listData.setCacheColorHint(Color.parseColor("#FFF1F1F1"));
                            listData.setDivider(new ColorDrawable(Color.parseColor("#00FFFFFF")));
                            listData.setDividerHeight(2);

                            mAdapter = new ItemAdapter(BusinessListActivity.this, 0, arrData);
                            listData.setAdapter(mAdapter);
                        }

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(BusinessListActivity.this, getString(R.string.fuwuqineibucuowu));

                        return;
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
                GlobalData.showToast(BusinessListActivity.this, error.getMessage());
                stopProgress();
            }
        };

        return;
    }

    class ItemAdapter extends ArrayAdapter<STServiceItem>
    {
        ArrayList<STServiceItem> list;
        Context ctx;

        public ItemAdapter(Context ctx, int resourceId, ArrayList<STServiceItem> list) {
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
                v = inflater.inflate(R.layout.view_businesslistitem, null);
                ResolutionSet._instance.iterateChild(v.findViewById(R.id.parent_layout));

                TextView lblTitle = (TextView) v.findViewById(R.id.lblData);
                lblTitle.setText(list.get(position).title);
                lblTitle.setTag(list.get(position));
                lblTitle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        STServiceItem item = (STServiceItem) v.getTag();
                        if (item != null)
                        {
                            Intent intent = new Intent(BusinessListActivity.this, ServiceDetailActivity.class);
                            intent.putExtra("MODE", nMode);
                            intent.putExtra("UID", item.uid);
                            intent.putExtra("TITLE", item.title);
                            intent.putExtra("CONTENT", item.content);
                            startActivity(intent);
                        }
                    }
                });
            }

            return v;
        }
    }
}
