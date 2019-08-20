<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*,com.xue.bbs.pojo.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
//从主页帖子页面获取需要更新的帖子id,title,cont
	request.setCharacterEncoding("utf-8");
	//为了session检查 防止报错，为null赋值为-1
	int id = Integer.parseInt(request.getParameter("id")  == null ? "-1" : request.getParameter("id"));
	//解决a标签get方式传值乱码1,但是因为tomcat已经get请求被我配置了URIEncoding="utf-8",此时不需要转码，否则又乱码
	//String title = new String(request.getParameter("title").getBytes(("iso8859-1")),"utf-8");
	String title = request.getParameter("title");
	String cont = request.getParameter("cont");
	String action = request.getParameter("action");
	
	//验证session
	String str = (String)session.getAttribute("user");
	if (str != null && str.equals("success") && id != -1) {
		//判断帖子信息
		if (action != null && action.equals("modify")) {
			//定义预编译处理类
			PreparedStatement pret = null;
			//定义返回结果集
			ResultSet rs = null;
			//定义数据库连接
			Connection con = null;
			try {
				//获取数据库连接
				con = DBUtils.getConnection();
				//编写sql修改语句
				String sql = "update article set title = ?,cont=? where id = ? ";
				//预编译sql语句，此时还没执行
				pret = con.prepareStatement(sql);
				pret.setString(1, title);
				pret.setString(2, cont);
				pret.setInt(3, id);
				int i = pret.executeUpdate();
				if (i == 1) {
					response.sendRedirect("article.jsp");
				}
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				DBUtils.close(con);
				DBUtils.close(pret);
				DBUtils.close(rs);
			}
		}
	 } else {
		response.sendRedirect("err.jsp");
	}
%>
<html>

	<head>
		<title>更新主题</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
		<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
		<!-- fckeditor -->
		<!-- 为了速度而没有使用fckeditor -->
		<!-- end of fckeditor -->

		<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
	</head>

	<body>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<td width="40%">
						<img src="images/header-stretch.gif" alt="" border="0" height="57" width="100%">
					</td>
					<td width="1%">
						<img src="images/header-right.gif" alt="" height="57" border="0">
					</td>
				</tr>
			</tbody>
		</table>
		<br>
		<div id="jive-flatpage">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr valign="top">
						<td width="99%">
							<p class="jive-breadcrumbs">
								<a href="articleFlat.jsp">首页</a> &#187;
								<a href="http://bbs.chinajavaworld.com/forumindex.jspa?categoryID=1">ChinaJavaWorld技术论坛|Java世界_中文论坛</a>
								&#187;
								<a href="http://bbs.chinajavaworld.com/category.jspa?categoryID=2">Java 2 Platform, Standard Edition (J2SE)</a> &#187;
								<a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20&amp;start=0">Java语言*初级版</a>
							</p>
							<p class="jive-page-title">
								修改
								<br>
							</p>
						</td>
						<td width="1%"><br>

							<br></td>
					</tr>
				</tbody>
			</table>
			<div class="jive-buttons">
				<br>
			</div>
			<br>
			<table border="0" cellpadding="0" cellspacing="0" width="930" height="61">
				<tbody>
					<tr valign="top">
						<td width="99%">
							<div id="jive-message-holder">
								<div class="jive-message-list">
									<div class="jive-table">
										<div class="jive-messagebox">

											<form action="modifyFlat.jsp" method="post">
												<input type="hidden" name="action" value="modify" />
												<input type="hidden" name="id" value="<%=id %>" />
												标题：
												<input type="text" name="title" value="<%=title%>">
												<br> 内容：
												<textarea name="cont" rows="15" cols="80"><%=cont %></textarea>
												<br>
												<input type="submit" value="确认修改" />
											</form>

										</div>
									</div>
								</div>
								<div class="jive-message-list-footer">
									<br>
								</div>
							</div>
						</td>
						<td width="1%">
							&nbsp;
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>

</html>