<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*,java.util.*,com.xue.bbs.pojo.*,java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
	public static void showTreeArticle(List<Article> list, Connection con, int pid, int grade) {
		PreparedStatement pret = null;
		//定义返回结果集
		ResultSet rs = null;
		try {
			//编写sql语句,查询pid值的帖子
			String sql = "select *from article where pid = ?";
			//预编译，此时还没有执行sql语句
			pret = con.prepareStatement(sql);
			//设置查询条件值
			pret.setInt(1, pid);
			//执行sql语句，返回结果集
			rs = pret.executeQuery();
			while (rs.next()) {
				Article article = new Article();
				//给Article赋值
				ArUtils.initArticle(article, rs);
				//单独设置等级
				article.setGrade(grade);
				//添加到集合中
				list.add(article);
				//判断是否为叶子节点
				boolean isleaff = article.getIsleaf();
				if (!isleaff) {
					pid = rs.getInt("id");
					showTreeArticle(list, con, pid, grade + 1);
				}
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			DBUtils.close(pret);
			DBUtils.close(rs);
		}
	}
%>

<%
	/*
	*此功能为展示论坛（树状）
	*/
	//定义List集合，存放Article
	List<Article> list = new ArrayList<Article>();
	//验证session
	String str = (String)session.getAttribute("user");
	if (str != null && str.equals("success")) {
		//获取数据库连接
		Connection con = DBUtils.getConnection();
		//集合，连接，pid,grade等级
		showTreeArticle(list, con, 0, 1);
		//关闭连接
		DBUtils.close(con);
	} else {
		response.sendRedirect("err.jsp");
	} 
%>

<%
	
%>

<html>

	<head>
		<title>Java论坛树型展示</title>
		<meta http-equiv="content-type" content="text/html; charset=utf8">
		<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
		<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
		<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?forumID=20">
		<script language="JavaScript" type="text/javascript" src="images/common.js"></script>
	</head>

	<body style="margin:0 15px 0 15px;">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<td width="40%"><img src="images/header-stretch.gif" alt="" border="0" height="57" width="100%">
					</td>
					<td width="1%"><img src="images/header-right.gif" alt="" height="57" border="0"></td>
				</tr>
			</tbody>
		</table>
		<br>
		<div id="jive-forumpage">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr valign="top">
						<td width="98%">
							<p class="jive-breadcrumbs">
								<!-- 搜索框 -->
								<form action="searchResult.jsp" method="post" >
									<input style="text-indent:2px;" type="text" name="keywords" />&nbsp;&nbsp;
									<input style="color:white;background:blue;" type="submit" value="文章搜索">
								</form>
								<!-- 退出按钮 -->
								<a style="color:blue;float:right;" href="exit.jsp">退出</a>
								<!-- 切换模式 -->
								<a style="color:blue;float:right;margin-right:10px;" href="articleFlat.jsp">切换到平板模式</a>
							</p>
							<p class="jive-breadcrumbs">论坛: Java语言交流
							</p>
							<p class="jive-description"> 探讨Java语言基础知识,基本语法等 大家一起交流 共同提高！谢绝任何形式的广告 </p>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="jive-buttons">
				<table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="jive-icon">
								<a href="post.jsp"><img src="images/post-16x16.gif" alt="发表新主题" border="0" height="16" width="16"></a>
							</td>
							<td class="jive-icon-label">
								<a id="jive-post-thread" href="post.jsp">发表新主题</a>
								<a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20&amp;isBest=1"></a>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<br>
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tbody>
					<tr valign="top">
						<td><span class="nobreak">
						</td>
					</tr>
				</tbody>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr valign="top">
						<td width="99%">
							<div class="jive-thread-list">
								<div class="jive-table">
									<table summary="List of threads" cellpadding="0" cellspacing="0" width="100%">
										<thead>
											<tr>
												<th class="jive-author"></th>
												<th class="jive-author"> 操作 </th>
												<th class="jive-author"> 主题 </th>
												<th class="jive-author">
													<nobr> 作者 &nbsp; </nobr>
												</th>
												<th class="jive-view-count">
													<nobr> 浏览 &nbsp; </nobr>
												</th>
												<th class="jive-msg-count" nowrap="nowrap"> 回复 </th>
												<th class="jive-last" nowrap="nowrap"> 最新帖子 </th>
											</tr>
										</thead>
										<!-- 开始 -->
										<%
											StringBuffer sf = new StringBuffer();
											for (Article ar : list) {
												int grade = ar.getGrade();
												sf.setLength(0);
												for (int i = 1; i < grade; i++) {
													sf.append("----");
												}
										%>
										<tbody>
											<tr class="">
												<td class="jive-first" nowrap="nowrap" width="1%">
													<div class="jive-bullet"> <img src="images/read-16x16.gif" alt="已读" border="0" height="16" width="16">
														<!-- div-->
													</div>
												</td>

												<td nowrap="nowrap" width="1%">
													<!-- 更新 -->
													<a href="modify.jsp?id=<%=ar.getId() %>&title=<%=ar.getTitle()%>&cont=<%=ar.getCont()%>">更新</a>
													<!-- 删除 -->
													<a href="delete.jsp?id=<%=ar.getId() %>&pid=<%=ar.getPid() %>&isleaf=<%=ar.getIsleaf() %>">删除</a>

												</td>

												<td class="jive-thread-name" width="95%">
													<a id="jive-thread-1" href="articleDetail.jsp?rootid=<%=ar.getRootid()%>&title=<%=ar.getTitle() %>"><%=sf + ar.getTitle() %></a>
												</td>
												<td class="jive-author" nowrap="nowrap" width="1%"><span class=""> <a href="http://bbs.chinajavaworld.com/profile.jspa?userID=226030">bjsxt</a> </span></td>
												<td class="jive-view-count" width="1%"> 10000</td>
												<td class="jive-msg-count" width="1%"> 0</td>
												<td class="jive-last" nowrap="nowrap" width="1%"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(ar.getPdate()) %><br>
													<div class="jive-last-post"><br> by:
														<a href="http://bbs.chinajavaworld.com/thread.jspa?messageID=780182#780182" title="jingjiangjun" style="">黄智学</a>
													</div>
												</td>
											</tr>
										</tbody>
										<% } %>
										<!-- end -->
										
									</table>
								</div>
							</div>
							<div class="jive-legend"></div>
						</td>
					</tr>
				</tbody>
			</table>
			<br>
			<br>
		</div>
	</body>

</html>