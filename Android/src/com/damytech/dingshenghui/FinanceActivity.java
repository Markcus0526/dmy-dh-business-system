package com.damytech.dingshenghui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.damytech.utils.ResolutionSet;

public class FinanceActivity extends Activity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;

    ImageView imgBack = null;
    ImageView imgUserInfo = null;
    RelativeLayout rlBank, rlCredit, rlInsurance, rlProperty, rlSmall;

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
                    Intent intentUserInfo = new Intent(FinanceActivity.this, UserInfoActivity.class);
                    startActivity(intentUserInfo);
                    break;
                case R.id.rlBank:
                    Intent intentBank = new Intent(FinanceActivity.this, BusinessListActivity.class);
                    intentBank.putExtra("MODE", 0);
                    startActivity(intentBank);
                    break;
                case R.id.rlCredit:
                    Intent intentCredit = new Intent(FinanceActivity.this, BusinessListActivity.class);
                    intentCredit.putExtra("MODE", 1);
                    startActivity(intentCredit);
                    break;
                case R.id.rlInsurance:
                    Intent intentInsurance = new Intent(FinanceActivity.this, BusinessListActivity.class);
                    intentInsurance.putExtra("MODE", 2);
                    startActivity(intentInsurance);
                    break;
                case R.id.rlProperty:
                    Intent intentProperty = new Intent(FinanceActivity.this, BusinessListActivity.class);
                    intentProperty.putExtra("MODE", 3);
                    startActivity(intentProperty);
                    break;
                case R.id.rlSmallMoney:
                    Intent intentSmall = new Intent(FinanceActivity.this, BusinessListActivity.class);
                    intentSmall.putExtra("MODE", 4);
                    startActivity(intentSmall);
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
        setContentView(R.layout.activity_finance);

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
        imgUserInfo = (ImageView) findViewById(R.id.imgUserInfo);
        imgUserInfo.setOnClickListener(onClickListener);

        rlBank = (RelativeLayout) findViewById(R.id.rlBank);
        rlBank.setOnClickListener(onClickListener);
        rlCredit = (RelativeLayout) findViewById(R.id.rlCredit);
        rlCredit.setOnClickListener(onClickListener);
        rlInsurance = (RelativeLayout) findViewById(R.id.rlInsurance);
        rlInsurance.setOnClickListener(onClickListener);
        rlProperty = (RelativeLayout) findViewById(R.id.rlProperty);
        rlProperty.setOnClickListener(onClickListener);
        rlSmall = (RelativeLayout) findViewById(R.id.rlSmallMoney);
        rlSmall.setOnClickListener(onClickListener);

        return;
    }
}
