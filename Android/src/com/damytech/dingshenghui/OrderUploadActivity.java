package com.damytech.dingshenghui;

import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STGoodOrderInfo;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ResolutionSet;
import org.json.JSONObject;

public class OrderUploadActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    long nGoodID = 0;
    int nCount = 1;
    int nTotalPrice = 0;
    int nUsedMark = 0;
    boolean bUsedMark = true;
    boolean bIsReject = false;

    ImageView imgBack;
    ImageView imgUsedMark, imgReject;

    Button btnPlus, btnMinus;
    Button btnUpload;

    TextView lblCount;
    TextView lblName;
    TextView lblPrice;
    TextView lblCountTitle;
    TextView lblTotalPrice;
    TextView lblPhone;
    TextView lblUsedMark;
    TextView lblRealUsedMark;
    TextView lblReject;

    STGoodOrderInfo stOrderInfo = new STGoodOrderInfo();
    JsonHttpResponseHandler handler = null;
    JsonHttpResponseHandler handlerOrder = null;

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
                case R.id.btnMinus:
                    if (nCount == 1)
                        return;
                    nCount--;
                    lblCount.setText("" + nCount);
                    lblCountTitle.setText(getString(R.string.shuliang) + (stOrderInfo.count - nCount));
                    nTotalPrice = stOrderInfo.price * nCount - (GetRealUseMark() / 100);
                    lblTotalPrice.setText(getString(R.string.zongjia) + nTotalPrice + getString(R.string.yuan));
                    break;
                case R.id.btnPlus:
                    if (nCount < stOrderInfo.count) {
                        nCount++;
                        lblCount.setText("" + nCount);
                        lblCountTitle.setText(getString(R.string.shuliang) + (stOrderInfo.count - nCount));
                        nTotalPrice = stOrderInfo.price * nCount - (GetRealUseMark() / 100);
                        lblTotalPrice.setText(getString(R.string.zongjia) + nTotalPrice + getString(R.string.yuan));
                    }
                    break;
                case R.id.imgIsMark:
                    if (bUsedMark)
                    {
                        bUsedMark = false;
                        imgUsedMark.setImageResource(R.drawable.unchecked);
                        lblRealUsedMark.setVisibility(View.INVISIBLE);
                        nTotalPrice = stOrderInfo.price * nCount;
                    }
                    else
                    {
                        bUsedMark = true;
                        imgUsedMark.setImageResource(R.drawable.checked);
                        lblRealUsedMark.setVisibility(View.VISIBLE);
                        nTotalPrice = stOrderInfo.price * nCount - (GetRealUseMark() / 100);
                    }
                    lblTotalPrice.setText(getString(R.string.zongjia) + nTotalPrice + getString(R.string.yuan));
                    break;
                case R.id.imgReject:
                    if (bIsReject)
                    {
                        bIsReject = false;
                        imgReject.setImageResource(R.drawable.unchecked);
                    }
                    else
                    {
                        bIsReject = true;
                        imgReject.setImageResource(R.drawable.checked);
                    }
                    break;
                case R.id.btnUpload:
                    startProgress();
                    CommManager.UploadOrderInfo(GlobalData.GetUserID(OrderUploadActivity.this), stOrderInfo.goodid, nCount, stOrderInfo.usingmark, nUsedMark, (bIsReject==true)?1:0, nTotalPrice, 0, handlerOrder );
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
        setContentView(R.layout.activity_orderupload);

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

        nGoodID = getIntent().getLongExtra("GOODID", 0);

        initControl();
        initHandler();

        startProgress();
        CommManager.GetGoodOrderInfo(GlobalData.GetUserID(OrderUploadActivity.this), nGoodID, handler);
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);
        imgUsedMark = (ImageView) findViewById(R.id.imgIsMark);
        imgUsedMark.setOnClickListener(onClickListener);
        imgReject = (ImageView) findViewById(R.id.imgReject);
        imgReject.setOnClickListener(onClickListener);

        btnMinus = (Button) findViewById(R.id.btnMinus);
        btnMinus.setOnClickListener(onClickListener);
        btnPlus = (Button) findViewById(R.id.btnPlus);
        btnPlus.setOnClickListener(onClickListener);
        btnUpload = (Button) findViewById(R.id.btnUpload);
        btnUpload.setOnClickListener(onClickListener);

        lblCount = (TextView) findViewById(R.id.lblCount);
        lblCountTitle = (TextView) findViewById(R.id.lblCountTitle);
        lblName = (TextView) findViewById(R.id.lblName);
        lblPrice = (TextView) findViewById(R.id.lblPrice);
        lblPhone = (TextView) findViewById(R.id.lblLinkPhone);
        lblUsedMark = (TextView) findViewById(R.id.lblUsedMark);
        lblRealUsedMark = (TextView) findViewById(R.id.lblRealUsedMark);
        lblReject = (TextView) findViewById(R.id.lblReject);
        lblTotalPrice = (TextView) findViewById(R.id.lblTotalPrice);

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

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        stOrderInfo = STGoodOrderInfo.decode(jsonData.getJSONObject("RETDATA"));

                        showGoodInfo();

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(OrderUploadActivity.this, getString(R.string.fuwuqineibucuowu));
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
                GlobalData.showToast(OrderUploadActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

        handlerOrder = new JsonHttpResponseHandler()
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
                        GlobalData.showToast(OrderUploadActivity.this, getString(R.string.dingdanshengchengchenggong));
                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(OrderUploadActivity.this, getString(R.string.fuwuqineibucuowu));
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
                GlobalData.showToast(OrderUploadActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }

    private int GetRealUseMark()
    {
        if (stOrderInfo.usingmark == 1) {
            if (stOrderInfo.usermark <= stOrderInfo.marklimit)
                nUsedMark = stOrderInfo.usermark;
            else
                nUsedMark = stOrderInfo.marklimit;
        }
        else
            nUsedMark = 0;

        return nUsedMark;
    }

    private void showGoodInfo()
    {
        if (stOrderInfo != null)
        {
            nTotalPrice = stOrderInfo.price;

            lblName.setText(stOrderInfo.goodname);
            lblPrice.setText("" + stOrderInfo.price + getString(R.string.yuan));
            lblCountTitle.setText(getString(R.string.shuliang) + (stOrderInfo.count - nCount));
            if (stOrderInfo.userphone.length() != ConstData.PHONENUM_LENGTH)
                lblPhone.setText("*****");
            else
            {
                lblPhone.setText(stOrderInfo.userphone.substring(0, 3) + "****" + stOrderInfo.userphone.substring(7, ConstData.PHONENUM_LENGTH));
            }

            if (stOrderInfo.usingmark == 0) // inposible
            {
                lblUsedMark.setText(getString(R.string.bunengliyong));
                lblUsedMark.setVisibility(View.VISIBLE);
                lblRealUsedMark.setVisibility(View.INVISIBLE);
            }
            else // posible
            {
                imgUsedMark.setVisibility(View.VISIBLE);
                lblUsedMark.setVisibility(View.VISIBLE);
                lblUsedMark.setText(getString(R.string.shiyongjifen) + stOrderInfo.marklimit);

                nTotalPrice = nTotalPrice - (GetRealUseMark() / 100);
                lblRealUsedMark.setText(getString(R.string.shiyongjifen1) + (GetRealUseMark() / 100) * 100);
            }

            if (stOrderInfo.isreject == 0)
            {
                lblReject.setVisibility(View.INVISIBLE);
                imgReject.setVisibility(View.INVISIBLE);
            }
            else
            {
                lblReject.setVisibility(View.VISIBLE);
                imgReject.setVisibility(View.VISIBLE);
            }

            lblTotalPrice.setText(getString(R.string.zongjia) + nTotalPrice + getString(R.string.yuan));
        }
    }
}
