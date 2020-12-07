package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author 栗舜顺
 * 2020/11/12 0012
 */
@Controller
public class MainController {

    @RequestMapping("/workbench/main/toIndex.do")
    public String toIndex(){

        return "workbench/main/index";
    }
}
