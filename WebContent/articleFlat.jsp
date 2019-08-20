<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*,java.util.*,com.xue.bbs.pojo.*,java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	/*
	*此功能为展示论坛（平板）
	*/
	
	//创建页对象
	Page pages = new Page();
	//定义List集合，存放Article
	List<Article> list = new ArrayList<Article>();
	//验证session
	String str = (String)session.getAttribute("user");
	if (str != null && str.equals("success")) {
		//获取数据库连接
		Connection con = DBUtils.getConnection();
		//定义预编译处理类
		PreparedStatement pret = null;
		//定义返回结果集
		ResultSet rs = null;
		//设置article总记录数
		int totalRecord = 0;
		
		//编写sql语句,查询父帖记录总数
		String sql = "select count(*) from article where pid = ?";
		try {
			//预编译sql语句，此时还没执行
			pret = con.prepareStatement(sql);
			//设置查询条件
			pret.setInt(1, 0);
			//执行sql语句，返回结果
			rs = pret.executeQuery();
			while (rs.next()) {
				totalRecord = rs.getInt(1);
			}
			
			//分页技术实现
			//设置每页数为2
			pages.setPageSize(2);
			//根据总记录数和每页数计算总页数
			pages.setTotalPage(totalRecord, 2);
			//获取当前页数,并设置(如果刚进来，就是为null，设置为1，为第一页，否则，为后面页数)
			int currentPage = request.getParameter("currentPage") == null ? 1 : Integer.parseInt(request.getParameter("currentPage"));
			//当上一页到0时，必须把值设回1
			currentPage = currentPage < 1 ? 1 : currentPage;
			//当下一页到最大页数+1时，必须把值设回最大页数
			currentPage = currentPage > pages.getTotalPage() ? pages.getTotalPage() : currentPage;
			pages.setCurrentPage(currentPage);
			
			//sql查询语句，limit 第二个？表示当前页面起,因为2条记录一页，为了保证每次开始(currentPage - 1)*2  第三个？表示显示2条记录
			sql = "select *from article where pid = ? order by pdate asc limit ?,? ";
			pret = con.prepareStatement(sql);
			//设置查询条件
			pret.setInt(1, 0);
			pret.setInt(2, (currentPage - 1)*2);
			pret.setInt(3, 2);
			//执行sql语句，返回结果
			rs = pret.executeQuery();
			while (rs.next()) {
				//每次查到一条记录，存放在article对象中
				Article article = new Article();
				ArUtils.initArticle(article, rs);
				list.add(article);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			DBUtils.close(con);
			DBUtils.close(pret);
			DBUtils.close(rs);
		}
	 } else {
		response.sendRedirect("err.jsp");
	} 

%>

<html>

	<head>
		<title>Java论坛平板展示</title>
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
								<a style="color:blue;float:right;margin-right:10px;" href="article.jsp">切换到树状模式</a>
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
								<a id="jive-post-thread" href="postFlat.jsp">发表新主题</a>
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
       	     第<%=pages.getCurrentPage() %>页
       	     共<%=pages.getTotalPage() %>页
          <span class="jive-paginator"> [
          <a href="articleFlat.jsp?currentPage=<%=1 %>">首页</a>
          <a href="articleFlat.jsp?currentPage=<%=pages.getCurrentPage() - 1 %>">上一页</a>
          <a href="articleFlat.jsp?currentPage=<%=pages.getCurrentPage() + 1 %>">下一页</a>
           <a href="articleFlat.jsp?currentPage=<%=pages.getTotalPage() %>">尾页</a>
           ] </span> </span>
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
												<th class="jive-last" nowrap="nowrap"> 发布时间 </th>
											</tr>
										</thead>
										<!-- 开始 -->
										<% for (Article ar : list) { %>
										<tbody>
											<tr class="">
												<td class="jive-first" nowrap="nowrap" width="1%">
													<div class="jive-bullet"> <img src="images/read-16x16.gif" alt="已读" border="0" height="16" width="16">
														<!-- div-->
													</div>
												</td>

												<td nowrap="nowrap" width="1%">
													<!-- 更新 -->
													<a href="modifyFlat.jsp?id=<%=ar.getId() %>&title=<%=ar.getTitle()%>&cont=<%=ar.getCont()%>">更新</a>
													<!-- 删除 -->
													<a href="deleteFlat.jsp?rootid=<%=ar.getRootid() %>">删除</a>
												</td>

												<td class="jive-thread-name" width="95%">
													<a id="jive-thread-1" href="articleDetailFlat.jsp?id=<%=ar.getId()%>&title=<%=ar.getTitle() %>"><%=ar.getTitle() %></a>
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