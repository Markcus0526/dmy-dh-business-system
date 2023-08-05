package com.damytech.dingshenghui;

import android.app.Activity;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.damytech.utils.ResolutionSet;

public class PayConfirmActivity extends Activity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    final int MODE_YINLIAN = 0;
    final int MODE_ZHIFUBAO = 1;
    final int MODE_YINHANGKA = 2;
    int nMode = MODE_YINLIAN;

    ImageView imgBack;
    ImageView imgYinLian, imgZhiFuBao, imgYinHangka;

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
                case R.id.imgSelectYinLian:
                    nMode = MODE_YINLIAN;
                    imgYinLian.setImageResource(R.drawable.selected);
                    imgZhiFuBao.setImageResource(R.drawable.unselected);
                    imgYinHangka.setImageResource(R.drawable.unselected);
                    break;
                case R.id.imgSelectZhiFuBao:
                    nMode = MODE_ZHIFUBAO;
                    imgYinLian.setImageResource(R.drawable.unselected);
                    imgZhiFuBao.setImageResource(R.drawable.selected);
                    imgYinHangka.setImageResource(R.drawable.unselected);
                    break;
                case R.id.imgSelectYinHangKa:
                    nMode = MODE_YINHANGKA;
                    imgYinLian.setImageResource(R.drawable.unselected);
                    imgZhiFuBao.setImageResource(R.drawable.unselected);
                    imgYinHangka.setImageResource(R.drawable.selected);
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
        setContentView(R.layout.activity_payconfirm);

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
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);
        imgYinLian = (ImageView) findViewById(R.id.imgSelectYinLian);
        imgYinLian.setOnClickListener(onClickListener);
        imgZhiFuBao = (ImageView) findViewById(R.id.imgSelectZhiFuBao);
        imgZhiFuBao.setOnClickListener(onClickListener);
        imgYinHangka = (ImageView)findViewById(R.id.imgSelectYinHangKa);
        imgYinHangka.setOnClickListener(onClickListener);

        return;
    }
}
