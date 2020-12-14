package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(TranRemark record);

    int insertSelective(TranRemark record);

    TranRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TranRemark record);

    int updateByPrimaryKey(TranRemark record);

    void insertTranRemarkByList(List<TranRemark> tranRemarkList);
}