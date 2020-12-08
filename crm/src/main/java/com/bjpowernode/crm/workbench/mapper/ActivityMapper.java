package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    int insertActivity(Activity activity);

    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    int selectCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityByIds(String[] ids);

    int updateActivity(Activity activity);

    List<Activity> selectAllActivity();

    List<Activity> selectActivityByIds(String[] ids);

    int insertActivityByList(List<Activity> activities);

    Activity selectActivityForDetailById(String id);

    List<Activity> selectActivityForDetailByClueId(String clueId);

    List<Activity> selectActivityForDetailByNameClueId(Map<String,Object> map);
}