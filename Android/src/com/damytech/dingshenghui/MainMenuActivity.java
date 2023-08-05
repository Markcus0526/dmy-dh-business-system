package com.damytech.dingshenghui;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STRecommendGoodItem;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.HorizontalPager;
import com.damytech.utils.ResolutionSet;
import com.damytech.utils.SmartImageView.SmartImageView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public class MainMenuActivity extends SuperActivity {
    final int SLIDE_IMG_SIZE = 35;
    final int SLIDE_MARGIN_SIZE = 40;
    final int MARGIN_BOTTOM = 10;

    RelativeLayout mainLayout;
    boolean bInitialized = false;

    ImageView imgUserInfo = null;
    RelativeLayout rlFinance = null;
    RelativeLayout rlUserInfo = null;
    RelativeLayout rlGallery = null;
    RelativeLayout rlNormal = null;
    RelativeLayout rlCar = null;
    RelativeLayout rlSpecial = null;

    ImageView mImgSlide[];
    HorizontalPager hpData = null;
    static int TIME_INTERVAL = 3000;
    Timer mTimer = new Timer();

    ArrayList<STRecommendGoodItem> arrData = new ArrayList<STRecommendGoodItem>();
    JsonHttpResponseHandler handler = null;

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            switch (v.getId())
            {
                case R.id.rlFinance:
                    Intent intentFinance = new Intent(MainMenuActivity.this, FinanceActivity.class);
                    startActivity(intentFinance);
                    break;
                case R.id.imgUserInfo:
                    Intent intentDetail = new Intent(MainMenuActivity.this, UserInfoActivity.class);
                    startActivity(intentDetail);
                    break;
                case R.id.rlUserService:
                    Intent intentUserService = new Intent(MainMenuActivity.this, UserInfoActivity.class);
                    startActivity(intentUserService);
                    break;
                case R.id.rlSpecGood:
                    Intent intentSpec = new Intent(MainMenuActivity.this, GoodListActivity.class);
                    intentSpec.putExtra("MODE", 0);
                    startActivity(intentSpec);
                    break;
                case R.id.rlNormalGood:
                    Intent intentNormal = new Intent(MainMenuActivity.this, GoodListActivity.class);
                    intentNormal.putExtra("MODE", 1);
                    startActivity(intentNormal);
                    break;
                case R.id.rlCar:
                    Intent intentCar = new Intent(MainMenuActivity.this, GoodListActivity.class);
                    intentCar.putExtra("MODE", 2);
                    startActivity(intentCar);
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
        setContentView(R.layout.activity_mainmenu);

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

        startProgress();
        CommManager.GetRecommendGoodList(handler);
    }

    private void initControl()
    {
        rlFinance = (RelativeLayout) findViewById(R.id.rlFinance);
        rlFinance.setOnClickListener(onClickListener);
        rlUserInfo = (RelativeLayout) findViewById(R.id.rlUserService);
        rlUserInfo.setOnClickListener(onClickListener);
        rlGallery = (RelativeLayout) findViewById(R.id.rlGallery);
        rlNormal = (RelativeLayout) findViewById(R.id.rlNormalGood);
        rlNormal.setOnClickListener(onClickListener);
        rlCar = (RelativeLayout) findViewById(R.id.rlCar);
        rlCar.setOnClickListener(onClickListener);
        rlSpecial = (RelativeLayout) findViewById(R.id.rlSpecGood);
        rlSpecial.setOnClickListener(onClickListener);

        hpData = (HorizontalPager)findViewById(R.id.rlGoods);
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

        imgUserInfo = (ImageView) findViewById(R.id.imgUserInfo);
        imgUserInfo.setOnClickListener(onClickListener);

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
                        JSONArray jsonArray = jsonData.getJSONArray("RETDATA");
                        String basePath = jsonData.getString("BASEURL");
                        for (int i = 0; i < jsonArray.length(); i++)
                        {
                            STRecommendGoodItem item = STRecommendGoodItem.decode(jsonArray.getJSONObject(i));
                            item.imgpath = basePath + item.imgpath;
                            arrData.add(item);

                            if (arrData == null || arrData.size() == 0)
                                return;
                        }

                        loadAdvertiseView();

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(MainMenuActivity.this, getString(R.string.fuwuqineibucuowu));

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
                GlobalData.showToast(MainMenuActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

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
            imgView.setImageUrl(arrData.get(i).imgpath, R.drawable.defback);
            imgView.setTag(arrData.get(i).uid);

            imgView.setOnClickListener( new View.OnClickListener() {
                @Override
                public void onClick(View v)
                {
                    Long Uid = (Long)v.getTag();
                    long nUid = Uid.longValue();

                    Intent intent = new Intent(MainMenuActivity.this, GoodDetailActivity.class);
                    intent.putExtra("GOODID", nUid);
                    startActivity(intent);
                }
            });
            hpData.addView(imgView);

            mImgSlide[i] = new ImageView(rlSlide.getContext());
            mImgSlide[i].setId(100 + i);
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

    @Override
    public void onBackPressed(){
        Intent intent = new Intent(MainMenuActivity.this, LoginActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }
}
