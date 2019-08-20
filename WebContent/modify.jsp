<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*,com.xue.bbs.pojo.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% 
	/*
	*此页面为更新帖子（树型）
	*/
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
		<title>Java|Java世界_中文论坛|ChinaJavaWorld技术论坛 : 初学java遇一难题！！望大家能帮忙一下 ...</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
		<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
		<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
		<script src="fckeditor/ckeditor.js"></script>
		<script src="fckeditor/samples/js/sample.js"></script>
		<link rel="stylesheet" href="toolbarconfigurator/lib/codemirror/neo.css">
	</head>

	<body>
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
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr valign="top">
					<td width="99%">
						<p class="jive-breadcrumbs">
							<a href="article.jsp">首页</a> &#187;
							<a href="http://bbs.chinajavaworld.com/forumindex.jspa?categoryID=1">ChinaJavaWorld技术论坛|Java世界_中文论坛</a> &#187;
							<a href="http://bbs.chinajavaworld.com/category.jspa?categoryID=2">Java 2 Platform, Standard Edition (J2SE)</a> &#187;
							<a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20&amp;start=0">Java语言*初级版</a>
						</p>
						<td width="1%">
							<div class="jive-accountbox"></div>
						</td>
				</tr>
			</tbody>
		</table>

		<div>
			<form action="modify.jsp" method="post">
				<input type="hidden" name="action" value="modify" />
				<input type="hidden" name="id" value="<%=id %>" />
				标题:
				<input type="text" name="title" value="<%=title %>" /><br> 内容:
				<div class="adjoined-bottom">
					<div class="grid-container">
						<div class="grid-width-100">
							<textarea name="cont" id="editor" rows="15" cols="100"><%=cont %></textarea><br>
						</div>
					</div>
				</div>
				<!-- <div class="adjoined-bottom">
						<div class="grid-container">
							<div class="grid-width-100">
								<div id="editor" runat="server" name="context">
									<h1>Hello world!</h1>
									<p>I'm an instance of <a href="https://ckeditor.com">CKEditor</a>.</p>
								</div>
							
							</div>
						</div>
					</div> -->
				<script>
					initSample();
				</script>
				<input type="submit" value="确认修改" />

			</form>
		</div>
		<div>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr>
						<td nowrap="nowrap" width="1%"><br><br></td>
						<td align="center" width="98%">
							<table border="0" cellpadding="0" cellspacing="0">
								<tbody>
									<tr>
										<td>
											<a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20"><img src="images/arrow-left-16x16.gif" alt="返回到主题列表" border="0" height="16" hspace="6" width="16"></a>
										</td>
										<td>
											<a href="article.jsp">返回到主题列表</a>
										</td>
									</tr>
								</tbody>
							</table>
						</td>
						<td nowrap="nowrap" width="1%">&nbsp;</td>
					</tr>
				</tbody>
			</table>

		</div>
	</body>

</html>