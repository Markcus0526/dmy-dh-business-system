package com.damytech.dingshenghui;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ResolutionSet;
import org.json.JSONObject;

public class LoginActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;

    boolean bRemPass = false;
    static long back_pressed;

    ImageView imgRemPass = null;
    TextView lblRemPass = null;
    EditText txtUserName = null;
    EditText txtPass = null;
    TextView lblForgetPass = null;
    Button btnRegister = null;
    Button btnLogin = null;

    JsonHttpResponseHandler handlerLogin = null;

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            switch (v.getId())
            {
                case R.id.imgRemPass:
                case R.id.lblRemPass:
                    bRemPass = !bRemPass;
                    if (bRemPass)
                        imgRemPass.setImageResource(R.drawable.checked);
                    else
                        imgRemPass.setImageResource(R.drawable.unchecked);
                    break;
                case R.id.lblDisPass:
                    Intent intentForgetPass = new Intent(LoginActivity.this, ReqPhoneActivity.class);
                    startActivity(intentForgetPass);
                    break;
                case R.id.btnRegister:
                    Intent intentRegister = new Intent(LoginActivity.this, RegisterActivity.class);
                    startActivity(intentRegister);
                    break;
                case R.id.btnLogin:
                    String strUserName = txtUserName.getText().toString();
                    if (strUserName.length() == 0)
                    {
                        GlobalData.showToast(LoginActivity.this, getString(R.string.qingshuruyonghuming));
                        return;
                    }
                    String strPassword = txtPass.getText().toString();
                    if (strPassword.length() == 0)
                    {
                        GlobalData.showToast(LoginActivity.this, getString(R.string.qingshurumima));
                        return;
                    }

                    if (strPassword.length() < ConstData.PASSWORD_LENGTH)
                    {
                        GlobalData.showToast(LoginActivity.this, getString(R.string.qingshuruwuweimima));
                        return;
                    }

                    startProgress();
                    CommManager.LoginUser(strUserName, strPassword, GlobalData.getIMEI(LoginActivity.this), handlerLogin);
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
        setContentView(R.layout.activity_login);

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
        bRemPass = GlobalData.GetPassFlag(LoginActivity.this);
        imgRemPass = (ImageView) findViewById(R.id.imgRemPass);
        if (bRemPass)
            imgRemPass.setImageResource(R.drawable.checked);
        else
            imgRemPass.setImageResource(R.drawable.unchecked);
        imgRemPass.setOnClickListener(onClickListener);
        lblRemPass = (TextView) findViewById(R.id.lblRemPass);
        lblRemPass.setOnClickListener(onClickListener);
        lblForgetPass = (TextView) findViewById(R.id.lblDisPass);
        lblForgetPass.setOnClickListener(onClickListener);

        txtUserName = (EditText) findViewById(R.id.txtUserID);
        txtPass = (EditText) findViewById(R.id.txtPassword);
        if (GlobalData.GetPassFlag(LoginActivity.this))
        {
            txtUserName.setText(GlobalData.GetUserName(LoginActivity.this));
            txtPass.setText(GlobalData.GetPass(LoginActivity.this));
        }
        else
        {
            txtUserName.setText("");
            txtPass.setText("");
        }

        btnRegister = (Button) findViewById(R.id.btnRegister);
        btnRegister.setOnClickListener(onClickListener);
        btnLogin = (Button) findViewById(R.id.btnLogin);
        btnLogin.setOnClickListener(onClickListener);
    }

    public void initHandler()
    {
        handlerLogin = new JsonHttpResponseHandler()
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
                        if (bRemPass)
                        {
                            long nUID = jsonData.getLong("RETDATA");

                            GlobalData.SetPassFlag(LoginActivity.this, true);
                            GlobalData.SetUserID(LoginActivity.this, nUID);
                            GlobalData.SetUserName(LoginActivity.this, txtUserName.getText().toString());
                            GlobalData.SetPass(LoginActivity.this, txtPass.getText().toString());
                        }
                        else
                        {
                            long nUID = jsonData.getLong("RETDATA");

                            GlobalData.SetPassFlag(LoginActivity.this, false);
                            GlobalData.SetUserID(LoginActivity.this, nUID);
                            GlobalData.SetUserName(LoginActivity.this, "");
                            GlobalData.SetPass(LoginActivity.this, "");
                        }

                        Intent intentLogin = new Intent(LoginActivity.this, MainMenuActivity.class);
                        startActivity(intentLogin);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTUSER)
                    {
                        String strRetMsg = jsonData.getString("RETDATA");
                        GlobalData.showToast(LoginActivity.this, strRetMsg);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        String strRetMsg = jsonData.getString("RETDATA");
                        GlobalData.showToast(LoginActivity.this, strRetMsg);

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
                GlobalData.showToast(LoginActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }

    @Override
    public void onBackPressed(){
        if (back_pressed + 2000 > System.currentTimeMillis()){
            super.onBackPressed();
        }
        else{
            GlobalData.showToast(LoginActivity.this, getString(R.string.exitapp));
            back_pressed = System.currentTimeMillis();
        }
    }
}
