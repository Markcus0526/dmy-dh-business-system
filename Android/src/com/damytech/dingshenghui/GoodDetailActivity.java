package com.damytech.dingshenghui;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STGoodDetailInfo;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.HorizontalPager;
import com.damytech.utils.NoZoomControllWebView;
import com.damytech.utils.ResolutionSet;
import com.damytech.utils.SmartImageView.SmartImageView;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public class GoodDetailActivity extends SuperActivity {
    final int SLIDE_IMG_SIZE = 35;
    final int SLIDE_MARGIN_SIZE = 40;
    final int MARGIN_BOTTOM = 10;

    ArrayList<String> arrData = new ArrayList<String>();
    ImageView mImgSlide[];
    HorizontalPager hpData = null;
    static int TIME_INTERVAL = 3000;
    Timer mTimer = new Timer();
    RelativeLayout rlGallery = null;

    RelativeLayout mainLayout;
    boolean bInitialized = false;
    long nGoodID = 0;

    ImageView imgBack;
    ImageView imgCall;

    TextView lblPrice = null;
    TextView lblName = null;
    TextView lblAddr = null;
    TextView lblPhone = null;
    TextView lblBuyDesc = null;

    ScrollView scrollView = null;
    NoZoomControllWebView webDesc = null;

    Button btnBuy = null;

    STGoodDetailInfo stDetailInfo = new STGoodDetailInfo();
    JsonHttpResponseHandler handler = null;

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
                case R.id.imgCall:
                    if (stDetailInfo.shopphone.length() > 0)
                    {
                        Intent intentCall = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + stDetailInfo.shopphone));
                        startActivity(intentCall);
                    }
                    break;
                case R.id.btnBuy:
                    Intent intentBuy = new Intent(GoodDetailActivity.this, OrderUploadActivity.class);
                    intentBuy.putExtra("GOODID", nGoodID);
                    startActivity(intentBuy);
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
        setContentView(R.layout.activity_gooddetail);

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
        CommManager.GetGoodDetailInfo(nGoodID, handler);
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);
        imgCall = (ImageView) findViewById(R.id.imgCall);
        imgCall.setOnClickListener(onClickListener);

        lblName = (TextView) findViewById(R.id.lblName);
        lblPrice = (TextView) findViewById(R.id.lblPrice);
        lblAddr = (TextView) findViewById(R.id.lblAddress);
        lblPhone = (TextView) findViewById(R.id.lblPhone);
        lblBuyDesc = (TextView) findViewById(R.id.lblAlarm);

        rlGallery = (RelativeLayout) findViewById(R.id.rlPost);

        scrollView = (ScrollView) findViewById(R.id.scrollView);
        scrollView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                webDesc.getParent().requestDisallowInterceptTouchEvent(false);
                return false;
            }
        });

        webDesc = (NoZoomControllWebView) findViewById(R.id.webDetail);
        webDesc.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url)
            {
                view.loadUrl(url);
                return true;
            };
        });

        webDesc.setOnTouchListener(new View.OnTouchListener(){
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                v.getParent().requestDisallowInterceptTouchEvent(true);
                return false;
            }
        });

        hpData = (HorizontalPager)findViewById(R.id.viewPhotos);
        hpData.setCurrentScreen(0, false);
        hpData.setOnScreenSwitchListener(new HorizontalPager.OnScreenSwitchListener()	{
            @Override
            public void onScreenSwitched(int screen) {
                hpData.setCurrentScreen(screen, false);
                if (arrData != null)
                {
                    for (int i = 0; i < arrData.size(); i++)
                    {
                        if (screen == i)
                            mImgSlide[i].setImageResource(R.drawable.redballoon);
                        else
                            mImgSlide[i].setImageResource(R.drawable.grayballoon);
                    }
                }
            }
        });

        btnBuy = (Button) findViewById(R.id.btnBuy);
        btnBuy.setOnClickListener(onClickListener);

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
                    String basePath = jsonData.getString("BASEURL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        stDetailInfo = STGoodDetailInfo.decode(jsonData.getJSONObject("RETDATA"));
                        if (stDetailInfo.imgpath1 != null && stDetailInfo.imgpath1.length() > 0)
                            arrData.add(basePath + stDetailInfo.imgpath1);
                        if (stDetailInfo.imgpath2 != null && stDetailInfo.imgpath2.length() > 0)
                            arrData.add(basePath + stDetailInfo.imgpath2);
                        if (stDetailInfo.imgpath3 != null && stDetailInfo.imgpath3.length() > 0)
                            arrData.add(basePath + stDetailInfo.imgpath3);
                        if (stDetailInfo.imgpath4 != null && stDetailInfo.imgpath4.length() > 0)
                            arrData.add(basePath + stDetailInfo.imgpath4);

                        showGoodDetailInfo();

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(GoodDetailActivity.this, getString(R.string.fuwuqineibucuowu));
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
                GlobalData.showToast(GoodDetailActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

        return;
    }

    private void showGoodDetailInfo()
    {
        lblPrice.setText("" + stDetailInfo.price + getString(R.string.yuan));
        lblName.setText(stDetailInfo.name);
        lblAddr.setText(stDetailInfo.shopaddr);
        lblPhone.setText(stDetailInfo.shopphone);
        if (stDetailInfo.shopphone != null && stDetailInfo.shopphone.length() == 0)
            imgCall.setVisibility(View.INVISIBLE);

        webDesc.setBackgroundColor(Color.parseColor("#FFFFFFFF"));
        webDesc.getSettings().setLoadWithOverviewMode(true);
        webDesc.getSettings().setUseWideViewPort(true);
        webDesc.getSettings().setBuiltInZoomControls(false);
        webDesc.getSettings().setDisplayZoomControls(false);
        webDesc.getSettings().setSupportZoom(false);
        webDesc.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);
        webDesc.getSettings().setDefaultTextEncodingName("UTF-8");
        webDesc.getSettings().setJavaScriptEnabled(true);
        webDesc.getSettings().setDefaultZoom(WebSettings.ZoomDensity.CLOSE);

        StringBuilder strData = new StringBuilder();
        strData.append("<html><head><meta content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\" name=\"viewport\">");
        strData.append("<meta content=\"no-cache,must-revalidate\" http-equiv=\"Cache-Control\">");
        strData.append("<meta content=\"no-cache\" http-equiv=\"pragma\">");
        strData.append("<meta content=\"0\" http-equiv=\"expires\">");
        strData.append("<meta content=\"telephone=no, address=no\" name=\"format-detection\">" + "<style>img { width:100%;} </style>" + "</head>");
        strData.append("<body>");
        strData.append(GlobalData.unescape(stDetailInfo.gooddesc));
        strData.append("</body></html>");
        webDesc.loadData(strData.toString(), "text/html; charset=UTF-8", "");

        lblBuyDesc.setText(stDetailInfo.buydesc);

        loadAdvertiseView();

        return;
    }

    private TimerTask intro_timer_task = null;
    public void startTimer()
    {
        intro_timer_task = new TimerTask() {
            @Override
            public void run() {
                runOnUiThread(mRunnable);
            }
        };
        mTimer.schedule(intro_timer_task, TIME_INTERVAL, TIME_INTERVAL);
    }

    public void stopTimer()
    {
        mTimer.cancel();
    }

    private Runnable mRunnable = new Runnable() {
        @Override
        public void run()
        {
            int nSelection = hpData.getCurrentScreen();
            if (arrData != null)
            {
                if (nSelection == (arrData.size()-1) )
                    nSelection = 0;
                else
                    nSelection++;

                hpData.setCurrentScreen(nSelection, true);

                for (int i = 0; i < arrData.size(); i++)
                {
                    if (nSelection == i)
                        mImgSlide[i].setImageResource(R.drawable.redballoon);
                    else
                        mImgSlide[i].setImageResource(R.drawable.grayballoon);
                }
            }
        }
    };

    public void loadAdvertiseView()
    {
        if (arrData == null || arrData.size() == 0)
            return;

        int nCount = arrData.size();

        mImgSlide = new ImageView[nCount];

        int nWidth = nCount * SLIDE_IMG_SIZE + (nCount-1) * SLIDE_MARGIN_SIZE;

        RelativeLayout rlSlide = new RelativeLayout(rlGallery.getContext());
        RelativeLayout.LayoutParams rlParam = new RelativeLayout.LayoutParams(nWidth, SLIDE_IMG_SIZE);
        rlParam.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        rlParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
        rlParam.setMargins(-1, -1, -1, MARGIN_BOTTOM                                                                            );
        rlSlide.setLayoutParams(rlParam);

        for (int i = 0; i < nCount; i++)
        {
            SmartImageView imgView = new SmartImageView(hpData.getContext());
            imgView.setScaleType(ImageView.ScaleType.CENTER);
            imgView.setImageUrl(arrData.get(i), R.drawable.defback);

            imgView.setOnClickListener( new View.OnClickListener() {
                @Override
                public void onClick(View v)
                {
                }
            });
            hpData.addView(imgView);

            mImgSlide[i] = new ImageView(rlSlide.getContext());
            mImgSlide[i].setId(100+i);
            RelativeLayout.LayoutParams param = new RelativeLayout.LayoutParams(SLIDE_IMG_SIZE, SLIDE_IMG_SIZE);
            if (i == 0)
            {
                mImgSlide[i].setImageResource(R.drawable.redballoon);
                param.addRule(RelativeLayout.ALIGN_LEFT, rlSlide.getId());
            }
            else
            {
                mImgSlide[i].setImageResource(R.drawable.grayballoon);
                param.addRule(RelativeLayout.RIGHT_OF, mImgSlide[i-1].getId());
                param.setMargins(SLIDE_MARGIN_SIZE, -1, -1, -1);
            }

            mImgSlide[i].setLayoutParams(param);
            rlSlide.addView(mImgSlide[i], mImgSlide[i].getLayoutParams());
        }

        rlGallery.addView(rlSlide, rlSlide.getLayoutParams());
        ResolutionSet._instance.iterateChild(rlSlide);

        startTimer();
    }
}
