package com.bjpowernode.crm.commons.domain;

/**
 * @author 栗舜顺
 * 2020/11/8 0008
 */
public class ReturnObject {

    /**
     * code只取两个值,0或1
     *  0代表失败,1代表成功
     */
    private String code;
    private String message;
    private Object data;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public static ReturnObject success(Object data){
        ReturnObject returnObject=new ReturnObject();
        returnObject.setCode("1");
        returnObject.setData(data);

        return returnObject;
    }

    public static ReturnObject success(){
        ReturnObject returnObject=new ReturnObject();
        returnObject.setCode("1");
        return returnObject;
    }

    public static ReturnObject error(String message){
        ReturnObject returnObject=new ReturnObject();
        returnObject.setCode("0");
        returnObject.setMessage(message);
        return returnObject;
    }


}
