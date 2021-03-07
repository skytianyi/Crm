package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.FunnelVO;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;

public interface TranMapper {
    int deleteByPrimaryKey(String id);

    int insert(Tran record);

    int insertSelective(Tran record);

    Tran selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Tran record);

    int updateByPrimaryKey(Tran record);

    /**
     * 保存创建的交易
     * @param tran
     * @return
     */
    int insertTran(Tran tran);

    /**
     * 查询交易的各个阶段的数量
     * @return
     */
    List<FunnelVO> selectCountOfTranGroupByStage();

    /**
     * 根据id查询交易的详细信息
     * @param id
     * @return
     */
    Tran selectTranForDetailById(String id);
}