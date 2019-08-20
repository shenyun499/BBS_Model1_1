package com.xue.bbs.pojo;

import java.util.Date;

/**
 * 帖子实体类
 * @author xuexue
 *
 */
public class Article {
	//帖子id
	private int id;
	//父帖pid(父帖为0则为主帖)
	private int pid;
	//属于哪一个主帖子(记录父贴为0的id)
	private int rootid;
	//帖子主题
	private String title;
	//帖子内容
	private String cont;
	//帖子等级（id=0为父贴）
	private int grade;
	//帖子时间
	private Date pdate;
	//帖子是否为叶子
	private boolean isleaf;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public int getRootid() {
		return rootid;
	}
	public void setRootid(int rootid) {
		this.rootid = rootid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCont() {
		return cont;
	}
	public void setCont(String cont) {
		this.cont = cont;
	}
	public int getGrade() {
		return grade;
	}
	public void setGrade(int grade) {
		this.grade = grade;
	}
	public Date getPdate() {
		return pdate;
	}
	public void setPdate(Date pdate) {
		this.pdate = pdate;
	}
	public boolean getIsleaf() {
		return isleaf;
	}
	public void setIsdeaf(int isleaf) {
		//是叶子节点为0，true
		this.isleaf = (isleaf == 0 ? true : false);
	}
}
