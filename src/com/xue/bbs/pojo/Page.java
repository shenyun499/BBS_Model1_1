package com.xue.bbs.pojo;
/**
 * 分页类
 * @author xuexue
 *
 */
public class Page {
	public static void main(String[] args) {
		int x = 4;
		System.out.println(9);
	}
	//当前页号
	private int currentPage;
	//总页数
	private int totalPage;
	//总记录数
	private int totalRecord;
	//每页数
	private int pageSize;
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalRecord, int pageSize) {
		int totalPage = totalRecord / pageSize;
		//偶数页不变，奇数页加1
		this.totalPage = totalRecord % pageSize == 0 ? totalPage : totalPage + 1;
	}
	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	
}
