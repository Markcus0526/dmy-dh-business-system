package com.damytech.dataclasses;

import org.json.JSONObject;

public class STGoodOrderInfo
{
    public long goodid = 0;
	public String goodname = "";
	public int price = 0;
	public int count = 0;
	public int usingmark = 0;
    public int marklimit = 0;
	public int usermark = 0;
	public String userphone = "";
	public int isreject = 0;

    public static STGoodOrderInfo decode(JSONObject jsonObj)
    {
        STGoodOrderInfo orderInfo = new STGoodOrderInfo();

        try { orderInfo.goodid = jsonObj.getLong("goodid"); } catch(Exception ex) {ex.printStackTrace();}
        try { orderInfo.goodname = jsonObj.getString("goodname"); } catch(Exception ex) {ex.printStackTrace();}
		try { orderInfo.price = jsonObj.getInt("price"); } catch(Exception ex) {ex.printStackTrace();}
		try { orderInfo.count = jsonObj.getInt("count"); } catch(Exception ex) {ex.printStackTrace();}
		try { orderInfo.usingmark = jsonObj.getInt("usingmark"); } catch(Exception ex) {ex.printStackTrace();}
        try { orderInfo.marklimit = jsonObj.getInt("marklimit"); } catch (Exception ex) {ex.printStackTrace();}
		try { orderInfo.usermark = jsonObj.getInt("usermark"); } catch(Exception ex) {ex.printStackTrace();}
        try { orderInfo.userphone = jsonObj.getString("userphone"); } catch(Exception ex) {ex.printStackTrace();}
		try { orderInfo.isreject = jsonObj.getInt("isreject"); } catch(Exception ex) {ex.printStackTrace();}

        return orderInfo;
    }
}