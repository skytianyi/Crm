package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.util.DateTimeUtil;
import com.bjpowernode.crm.commons.util.MD5Util;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * @author 栗舜顺
 * 2020/11/8 0008
 */
@Controller
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {

        return "/settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public ReturnObject login(String loginPwd, String loginAct, String isRemPwd, HttpServletRequest request, HttpServletResponse response) {
        String md5LoginPwd=MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();

        Map<String, Object> map = new HashMap<>();
        map.put("loginPwd", md5LoginPwd);
        map.put("loginAct", loginAct);
        User user = userService.queryUserByLoginActAndLoginPwd(map);
        if (user == null) {
           return ReturnObject.error("用户名或密码有误");
        } else if(DateTimeUtil.getFormatDateTime(new Date()).compareTo(user.getExpiretime())>0){
            return ReturnObject.error("账户已失效");
        }else if(MyConstans.LOCK_STATE_CLOSE.equals(user.getLockstate())){
            return ReturnObject.error("账户已被锁定");
        }else if(!user.getAllowips().contains(ip)){
            return ReturnObject.error("ip受限");
        }

        //运行到此说明账户登录成功
        user.setLoginpwd(loginPwd);
        request.getSession().setAttribute(MyConstans.USER, user);

        //实现十天免登陆
        if("true".equals(isRemPwd)){
            Cookie cookie1=new Cookie("loginAct",loginAct );
            Cookie cookie2=new Cookie("loginPwd",loginPwd);

            cookie1.setMaxAge(60*60*24*10);
            cookie2.setMaxAge(60*60*24*10);

            response.addCookie(cookie1);
            response.addCookie(cookie2);

        //没有点击十天免登陆将cookie删除
        }else {
            //覆盖
            Cookie cookie1=new Cookie("loginAct","0" );
            Cookie cookie2=new Cookie("loginPwd","0");

            cookie1.setMaxAge(0);
            cookie2.setMaxAge(0);

            response.addCookie(cookie1);
            response.addCookie(cookie2);

        }

        return ReturnObject.success(user);
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response, HttpSession session){
        Cookie cookie1=new Cookie("loginAct","0" );
        Cookie cookie2=new Cookie("loginPwd","0");

        cookie1.setMaxAge(0);
        cookie2.setMaxAge(0);

        response.addCookie(cookie1);
        response.addCookie(cookie2);

        session.invalidate();

        //跳转到登录页,因为在web-inf下无法直接访问，所以需要进入到controller,
        // 以下return两个都可，因为此项目"/"就是直接进入登录页
//        return "redirect:/settings/qx/user/toLogin.do";
        return "redirect:/";
    }


}
