package com.bjpowernode.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author 栗舜顺
 * 2020/11/7 0007
 */
@Controller
public class IndexController {

    @RequestMapping("/")
    public String toIndex(){
        return "index";
    }



}
