package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.util.DateTimeUtil;
import com.bjpowernode.crm.commons.util.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/26 0026
 */
@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<Clue> queryClueByCondition(Map<String, Object> map) {
        return clueMapper.selectClueByCondition(map);
    }

    @Override
    public int queryCountClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountClueByCondition(map);
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        User user= (User) map.get(MyConstans.USER);
        String clueId = (String) map.get("clueId");
        String isCreateTransaction= (String) map.get("isCreateTransaction");
        //查询线索信息
        Clue clue = clueMapper.selectClueById(clueId);


        //把线索中有关公司的信息转换到客户表中
        Customer customer=new Customer();
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
        customer.setCreateBy(user.getId());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setContactSummary(clue.getContactSummary());
        customer.setOwner(user.getId());
        customer.setDescription(clue.getDescription());
        customer.setName(clue.getCompany());
        customer.setAddress(clue.getAddress());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customerMapper.insertCustomerSelective(customer);

        //把该线索中有关个人的信息转换到联系人表中
        Contacts contacts=new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setMphone(clue.getMphone());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAddress(clue.getAddress());
        contacts.setSource(clue.getSource());
        contacts.setAppellation(clue.getAppellation());
        contacts.setCustomerId(customer.getId());
        contacts.setOwner(user.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setEmail(clue.getEmail());
        contactsMapper.insertSelective(contacts);

        //根据clueId查询该线索下所有的备注信息
        List<ClueRemark> crList = clueRemarkMapper.selectClueRemarkByClueId(clueId);

        //把该线索下所有的备注转换到客户备注表中一份
        if(crList!=null && crList.size()>0){
            //遍历crList，封装CustomerRemark对象
            CustomerRemark cur=null;
            List<CustomerRemark> curList=new ArrayList<>();
            for(ClueRemark cr:crList){
                cur=new CustomerRemark();

                cur.setCreateBy(cr.getCreateBy());
                cur.setCreateTime(cr.getCreateTime());
                cur.setCustomerId(customer.getId());
                cur.setEditBy(cr.getEditBy());
                cur.setEditFlag(cr.getEditFlag());
                cur.setEditTime(cr.getEditTime());
                cur.setId(UUIDUtil.getUUID());
                cur.setNoteContent(cr.getNoteContent());

                curList.add(cur);
            }

            customerRemarkMapper.insertCustomerRemarkByList(curList);
        }

        //把该线索中下所有的备注转到联系人备注表中一份
        if(crList!=null &&crList.size()>0){
            ContactsRemark contactsRemark=null;
            List<ContactsRemark> contrList=new ArrayList<>();

            for (ClueRemark cr : crList) {
                contactsRemark=new ContactsRemark();
                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setNoteContent(cr.getNoteContent());
                contactsRemark.setEditFlag(cr.getEditFlag());
                contactsRemark.setCreateTime(cr.getCreateTime());
                contactsRemark.setCreateBy(cr.getCreateBy());
                contactsRemark.setEditBy(cr.getEditBy());
                contactsRemark.setEditTime(cr.getEditTime());
                contrList.add(contactsRemark);
            }

            contactsRemarkMapper.insertContactsRemarkByList(contrList);
        }

        //根据clueId查询该线索和市场活动的关联关系
        List<ClueActivityRelation> carList = clueActivityRelationMapper.selectCluActRelationByClueId(clueId);

        //把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
        if(carList!=null && carList.size()>0){

            ContactsActivityRelation conar=null;
            List<ContactsActivityRelation> conActRelList=new ArrayList<>();

            for (ClueActivityRelation car : carList) {
                conar=new ContactsActivityRelation();
                conar.setId(UUIDUtil.getUUID());
                conar.setContactsId(contacts.getId());
                conar.setActivityId(car.getActivityId());
                conActRelList.add(conar);
            }

            contactsActivityRelationMapper.insertConActRelByList(conActRelList);
        }

        //如果需要创建交易,还要往交易表中添加一条记录

        if("true".equals(isCreateTransaction)){
            Tran tran=new Tran();
            tran.setId(UUIDUtil.getUUID());
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
            tran.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
            tran.setCreateBy(user.getId());
            tran.setMoney((String)map.get("money"));
            tran.setStage((String)map.get("stage"));//TODO
            tran.setName((String)map.get("name"));
            tran.setActivityId((String)map.get("activityId"));
            tran.setExpectedDate((String)map.get("expectedDate"));//TODO
            tran.setOwner(user.getId());

            //type source description contactSummary nextContactTime
            tranMapper.insertSelective(tran);

            //如果需要创建交易,还要把线索的备注信息转换到交易备注表中一份
            TranRemark tranRemark=null;
            List<TranRemark> trList=new ArrayList<>();
            for (ClueRemark cr: crList) {
                tranRemark=new TranRemark();

                tranRemark.setId(UUIDUtil.getUUID());
                tranRemark.setCreateBy(cr.getCreateBy());
                tranRemark.setCreateTime(cr.getCreateTime());
                tranRemark.setEditFlag(cr.getEditFlag());
                tranRemark.setEditBy(cr.getEditBy());
                tranRemark.setEditTime(cr.getEditTime());
                tranRemark.setNoteContent(cr.getNoteContent());
                tranRemark.setTranId(tran.getId());
                trList.add(tranRemark);
            }
            tranRemarkMapper.insertTranRemarkByList(trList);
        }

        //   删除线索的备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        //	    删除线索和市场活动的关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        //	    删除线索
        clueMapper.deleteByPrimaryKey(clueId);

    }
}
