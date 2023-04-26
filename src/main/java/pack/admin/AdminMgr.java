package pack.admin;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import pack.dbcp.DBConnectionMgr;
import pack.member.MemberBean;
import pack.member.MemberLoginBean;

public class AdminMgr {
	Connection conn;
	Statement stmt;
	PreparedStatement pstmt;
	ResultSet rs;
	DBConnectionMgr pool;
	MultipartRequest multi;
	
	private static final String SAVEFOLDER = "D:/AJR_20230126/Hong/silsp/p08_JSP/cheers_0420/src/main/webapp/noticeupload";
	private static String encType = "UTF-8";
	private static int maxSize = 50 * 1024 * 1024; // 5mbyte 제한
	public AdminMgr() {
		pool = DBConnectionMgr.getInstance();
		try {
			conn = pool.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public boolean login(String id, String pw) {
		boolean flag = false;
		String sql;
		try {
			sql = "select * from admin where admid = ? and admpw = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			
			rs = pstmt.executeQuery();
			if(rs.next()) flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	public void insertNotice(HttpServletRequest request) {
		String sql;
		String filename = null;
		String oriFilename = null;
		int filesize = 0;
		try {
			sql = "insert into notice (admid, admname, subject, content, ";
			sql += "readcnt, filename, oriFilename, filesize, post, fixed, ";
			sql += "type) values(?,?,?,?,0,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			
			File file = new File(SAVEFOLDER);
			
			if(!file.exists()) {
				file.mkdir();
			}
			
			multi = new MultipartRequest(request, SAVEFOLDER, maxSize, encType, new DefaultFileRenamePolicy());
			if(multi.getFilesystemName("filename")!=null) {
				filename = multi.getFilesystemName("filename");
				oriFilename = multi.getOriginalFileName("filename");
				filesize = (int)multi.getFile("filename").length();
			}
			pstmt.setString(1, multi.getParameter("admId"));
			pstmt.setString(2, multi.getParameter("admName"));
			pstmt.setString(3, multi.getParameter("subject"));
			pstmt.setString(4, multi.getParameter("content"));
			pstmt.setString(5, filename);
			pstmt.setString(6, oriFilename);
			pstmt.setInt(7, filesize);
			pstmt.setInt(8, Integer.parseInt(multi.getParameter("post")));
			pstmt.setInt(9, Integer.parseInt(multi.getParameter("fixed")));
			pstmt.setInt(10, Integer.parseInt(multi.getParameter("type")));
			
			pstmt.executeUpdate();
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
	}
	
	public List<AdmBoardBean> getNoticeList(String keyWord, String keyField, int start, int end){
		String sql;
		List<AdmBoardBean> list = new ArrayList<>(); 
		try {
			stmt = conn.createStatement();
			if(keyWord==null||keyWord.equals("")) {
				sql = "select * from notice";
			} else {
				sql = "select * from notice where "+keyField+" like "+"%"+keyWord+"%"+" and post = 1 ";
				sql += "order by num limit "+start+","+end+"";
			}
			rs = stmt.executeQuery(sql);
			while(rs.next()) {
				int num = rs.getInt("num");
				String admId = rs.getString("admId");
				String admName = rs.getString("admName");
				String subject = rs.getString("subject");
				String content = rs.getString("content");
				int readcnt = rs.getInt("readcnt");
				String filename = rs.getString("filename");
				String oriFilename = rs.getString("oriFilename");
				int filesize = rs.getInt("filesize");
				int post = rs.getInt("post");
				int fixed = rs.getInt("fixed");
				int type = rs.getInt("type");
				String saveTM = rs.getString("saveTM");
				String postTM = rs.getString("postTM");
				AdmBoardBean bean = new AdmBoardBean(num, admId, admName, subject, content, readcnt, filename, oriFilename, filesize, post, fixed, type, saveTM, postTM);
				list.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	public AdmBoardBean getNotice(int numParam){
		String sql;
		AdmBoardBean bean = null;
		try {
			stmt = conn.createStatement();
			sql = "select * from notice where num = "+numParam+"";
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				int num = rs.getInt("num");
				String admId = rs.getString("admId");
				String admName = rs.getString("admName");
				String subject = rs.getString("subject");
				String content = rs.getString("content");
				int readcnt = rs.getInt("readcnt");
				String filename = rs.getString("filename");
				String oriFilename = rs.getString("oriFilename");
				int filesize = rs.getInt("filesize");
				int post = rs.getInt("post");
				int fixed = rs.getInt("fixed");
				int type = rs.getInt("type");
				String saveTM = rs.getString("saveTM");
				String postTM = rs.getString("postTM");
				bean = new AdmBoardBean(num, admId, admName, subject, content, readcnt, filename, oriFilename, filesize, post, fixed, type, saveTM, postTM);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return bean;
	}
	
	public void upCount(int num) {
		String sql = "update notice set readcnt = readcnt+1 where num = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public int updateNotice(HttpServletRequest req) {
		int exeCnt = 0;
		String sql;
		try {
			multi = new MultipartRequest(req, SAVEFOLDER, maxSize, encType, new DefaultFileRenamePolicy());
			String filename = multi.getFilesystemName("filename");
			
			if(filename==null) {
				sql = "update notice set subject = ?, content = ?, post = ?, fixed = ?, type = ? where num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, multi.getParameter("subject"));
				pstmt.setString(2, multi.getParameter("content"));
				pstmt.setInt(3, Integer.parseInt(multi.getParameter("post")));
				pstmt.setInt(4, Integer.parseInt(multi.getParameter("fixed")));
				pstmt.setInt(5, Integer.parseInt(multi.getParameter("type")));
				pstmt.setInt(6, Integer.parseInt(multi.getParameter("num")));
				exeCnt = pstmt.executeUpdate();
				
			} else {
				sql = "select filename from notice where num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(multi.getParameter("num")));
				rs = pstmt.executeQuery();
				rs.next();
				String oldFile = rs.getString(1);
				String fileSrc = SAVEFOLDER + "/" + oldFile;
				File file = new File(fileSrc);
				file.delete();
				
				sql = "update notice set subject = ?, content = ?, post = ?, fixed = ?, type = ?, ";
				sql += "filename = ?, oriFilename = ?, filesize = ? where num = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, multi.getParameter("subject"));
				pstmt.setString(2, multi.getParameter("content"));
				pstmt.setInt(3, Integer.parseInt(multi.getParameter("post")));
				pstmt.setInt(4, Integer.parseInt(multi.getParameter("fixed")));
				pstmt.setInt(5, Integer.parseInt(multi.getParameter("type")));
				pstmt.setString(6, filename);
				pstmt.setString(7, multi.getOriginalFileName("filename"));
				pstmt.setInt(8, (int)multi.getFile("filename").length());
				pstmt.setInt(9, Integer.parseInt(multi.getParameter("num")));
				exeCnt = pstmt.executeUpdate();
			}
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
		
		return exeCnt;
	}
	
	public int getTotalRecord() {
		int recordCnt = 0;
		String sql= "select count(*) from notice";
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if(rs.next()) recordCnt = rs.getInt(1);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return recordCnt;
	}
	public List<MemberLoginBean> previewUserInfo(){
		List<MemberLoginBean> list = new ArrayList<MemberLoginBean>();
		
		try {
			String 	sql = "select t1.num, t1.uid, t1.logincnt, t1.loginip,t1.logintm,conndev from loginInfo as t1, ";
					sql += "(select uid, max(logincnt) as max_logincnt from loginInfo group by uid) as t2 ";
					sql += "where t1.logincnt = t2.max_logincnt and t1.uid = t2.uid";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				MemberLoginBean bean = new MemberLoginBean();
				bean.setNum(rs.getInt("num"));
				bean.setUid(rs.getString("uid"));
				bean.setLogincnt(rs.getInt("logincnt"));
				bean.setLoginip(rs.getString("loginip"));
				bean.setLogintm(rs.getString("logintm"));
				bean.setConndev(rs.getString("conndev"));
				list.add(bean);
				
			}
			
		} catch (SQLException e) {
		e.printStackTrace();
		
		}
		return list;
	}
	// 유저 정보 미리보기 종료
	
	// 유저 정보 상세보기 시작
	
		public List<MemberLoginBean> userInfo(String keyField, String keyWord, int start, int end){
			List<MemberLoginBean> list = new ArrayList<MemberLoginBean>();
			
			try {
				
				String sql = "delete from loginInfo2";
				pstmt = conn.prepareStatement(sql);
				pstmt.execute();

				sql = "insert into loginInfo2 select t1.num, t1.uid, t1.logincnt, t1.loginip,t1.logintm,conndev from loginInfo as t1, ";
				sql += "(select uid, max(logincnt) as max_logincnt from loginInfo group by uid) as t2 ";
				sql += "where t1.logincnt = t2.max_logincnt and t1.uid = t2.uid";
				pstmt = conn.prepareStatement(sql);
				pstmt.execute();
				
				if(keyWord.equals("null")||keyWord.equals("")) {
					sql = "select * from loginInfo2";
					sql	+= " limit ?, ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);
				} else {
					sql = "select * from loginInfo2 where "+keyField+" like ?" 
							+" limit ?, ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, "%"+keyWord+"%");
					pstmt.setInt(2, start);
					pstmt.setInt(3, end);
				}
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					MemberLoginBean bean = new MemberLoginBean();
					bean.setNum(rs.getInt("num"));
					bean.setUid(rs.getString("uid"));
					bean.setLogincnt(rs.getInt("logincnt"));
					bean.setLoginip(rs.getString("loginip"));
					bean.setLogintm(rs.getString("logintm"));
					bean.setConndev(rs.getString("conndev"));
					list.add(bean);
				}
	
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(conn, pstmt, rs);
			}
			return list;
		}
		// 유저 정보 상세보기 종료
	
		// 총 유저 정보 수 시작
		public int getTotalCount(String keyField, String keyWord) {
			String sql;
			int totalCnt=0;
			
			try {
				
				sql = "delete from loginInfo2";
				pstmt = conn.prepareStatement(sql);
				pstmt.execute();

				sql = "insert into loginInfo2 select t1.num, t1.uid, t1.logincnt, t1.loginip,t1.logintm,conndev from loginInfo as t1, ";
				sql += "(select uid, max(logincnt) as max_logincnt from loginInfo group by uid) as t2 ";
				sql += "where t1.logincnt = t2.max_logincnt and t1.uid = t2.uid";
				pstmt = conn.prepareStatement(sql);
				pstmt.execute();
				
				if(keyWord.equals("null")||keyWord.equals("")) {
					sql = "select count(*) from loginInfo2";
					pstmt = conn.prepareStatement(sql);
				} else {
					sql = "select count(*) from loginInfo2"
							+" where "+keyField+" like ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, "%"+keyWord+"%");
				}
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					totalCnt = rs.getInt(1);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return totalCnt;
		}
		
		
	// 유저 정보 시작
	
	public Vector<MemberBean> getUserInfo(String keyField, String keyWord, int start, int end){
		Vector<MemberBean> list = new Vector<>();
		
		try {
			String sql;
			
			if(keyWord.equals("null")||keyWord.equals("")) {
				sql = "select * from admin";
				sql	+= " limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			} else {
				sql = "select * from admin where "+keyField+" like ?" 
						+" limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyWord+"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				MemberBean bean = new MemberBean();
				bean.setUid(rs.getString("uid"));
				bean.setUname(rs.getString("uname"));
				bean.setUemail(rs.getString("uemail"));
				bean.setGender(rs.getString("gender"));
				bean.setUbirthday(rs.getString("ubirthday"));
				bean.setUzipcode(rs.getString("uzipcode"));
				bean.setUaddr(rs.getString("uaddr"));
				String[] hobbyArr = new String[5];
				String hobby = rs.getString("uhobby");
				hobbyArr = hobby.split("");
				bean.setUhobby(hobbyArr);
				bean.setUjob(rs.getString("ujob"));
				bean.setJointm(rs.getString("jointm"));
				
				list.add(bean);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt, rs);
		}
		return list;
	}
	
	// 유저 정보 종료
}
