package pack.gallery;

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

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.FileRenamePolicy;

import pack.bbs.UtilMgr;
import pack.dbcp.DBConnectionMgr;



public class GalleryMgr {
private DBConnectionMgr pool;
	
	Connection conn;
	PreparedStatement pstmt;
	Statement stmt;
	ResultSet rs;
	
	private static final String SAVEFOLDER = "D:/AJR_20230126/Hong/silsp/p08_JSP/cheers_0420/src/main/webapp/galleryupload";
	private static String encType = "UTF-8";
	private static int maxSize = 50 * 1024 * 1024; // 5mbyte 제한
	
	public GalleryMgr() {
		pool = DBConnectionMgr.getInstance();
		try {
			conn = pool.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public boolean insertGallery(HttpServletRequest req) {
		String sql;
		MultipartRequest multi;
		int filesize = 0;
		String filename = null;
		String OriginalFileName = null;
		boolean flag = false;
		
		sql = "select max(num) from tblgallery";
		try {
			pstmt= conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			File file = new File(SAVEFOLDER);
			
			if(!file.exists()) {
				file.mkdir();
			}
			multi = new MultipartRequest(req, SAVEFOLDER, maxSize, encType, new DefaultFileRenamePolicy());
			
			if(multi.getFilesystemName("filename")==null) flag = false;
			else {
				OriginalFileName = multi.getOriginalFileName("filename");
				filename = multi.getFilesystemName("filename");
				filesize = (int)multi.getFile("filename").length();
				String content = multi.getParameter("content");
				
				if(multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
					content = UtilMgr.replace(content, "<", "&lt");
				}
				
				sql = "insert into tblgallery(";
				sql += "uid, uname, subject, content, ";
				sql += "ip, readcnt, filename, filesize, oriFilename) values(";
				sql += "?,?,?,?,?,0,?,?,?)";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, multi.getParameter("uid"));
				pstmt.setString(2, multi.getParameter("uname"));
				pstmt.setString(3, multi.getParameter("subject"));
				pstmt.setString(4, content);
				pstmt.setString(5, multi.getParameter("ip"));
				pstmt.setString(6, filename);
				pstmt.setInt(7, filesize);
				pstmt.setString(8, OriginalFileName);
				int exeCnt = pstmt.executeUpdate();
				if(exeCnt == 1) flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt, rs);
		}
		return flag;
	}
	
	// 게시판 리스트 출력(/gallery/list.jsp) 시작
	public Vector<GalleryBean> getGalleryList(String keyField, String keyWord, int start, int end){
		Vector<GalleryBean> list = new Vector<>();
		String sql;
		
		try {
			if(keyWord.equals("null")||keyWord.equals("")) {
				sql = "select * from tblgallery order by num desc";
				sql	+= " limit ?,?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			} else {
				sql = "select * from tblgallery where "+keyField+" like ?" 
						+" order by num limit ?,?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyWord+"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
			}
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int num = rs.getInt("num");
				String uid = rs.getString("uid");
				String uname = rs.getString("uname");
				String subject = rs.getString("subject");
				String content = rs.getString("content");
				String regtm = rs.getString("regtm");
				String ip = rs.getString("ip");
				int readcnt = rs.getInt("readcnt");
				String filename = rs.getString("filename");
				String oriFilename = rs.getString("oriFilename");
				int filesize = rs.getInt("filesize");
				GalleryBean bean = new GalleryBean(num, uid, uname, subject, content, regtm, ip, readcnt, filename, oriFilename, filesize);
				list.add(bean);
			}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(conn, pstmt, rs);
			}
		
		return list;
	}
	
	public int getTotalGallery(String keyField, String keyWord) {
		int res = 0;
		String sql;
		try {
			if(keyWord.equals("")||keyWord.equals("null")) {
				sql = "select count(*) from tblgallery";
				pstmt = conn.prepareStatement(sql);
			} else {
				sql = "select count(*) from tblgallery where "+keyField+" like ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyWord+"%");
			}
			rs = pstmt.executeQuery();
			
			if(rs.next()) res = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}
	
	public GalleryBean getGallery(int num) {
		String sql;
		GalleryBean bean = null;
		try {
			stmt = conn.createStatement();
			sql = "select * from tblgallery where num = "+num;
			rs = stmt.executeQuery(sql);
			rs.next();
			
			bean = new GalleryBean(rs.getInt("num"), rs.getString("uid"), rs.getString("uname"), rs.getString("subject"), rs.getString("content"), rs.getString("regtm"), rs.getString("ip"), rs.getInt("readcnt"), rs.getString("filename"), rs.getString("oriFilename"), rs.getInt("filesize"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return bean;
	}
	
	public void upCount(int num) {
		String sql;
		try {
			sql = "update tblgallery set readcnt = readcnt+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			pool.freeConnection(conn, pstmt);
		}
	}
	
	public int updateGallery(HttpServletRequest req) {
		int flag = 0;
		String sql = "";
		MultipartRequest multi;
		try {
			multi = new MultipartRequest(req, SAVEFOLDER, maxSize, encType, new DefaultFileRenamePolicy());
			
			sql = "select oriFilename, filename from tblgallery where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,Integer.parseInt(multi.getParameter("num")));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String filename = multi.getFilesystemName("filename");
				String oldFile = rs.getString("filename");
				
				if(filename!=null) {
					String oriFilename = multi.getOriginalFileName("filename");
					if(!rs.getString("oriFilename").equals(oriFilename)) {
						int filesize = (int)multi.getFile("filename").length();
						String fileSrc = SAVEFOLDER+"/"+oldFile;
						File file = new File(fileSrc);
						file.delete();
						
						sql = "update tblgallery set subject = ?, content = ?, ";
						sql += "filename = ?, filesize = ?, oriFilename = ? where num=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, multi.getParameter("subject"));
						pstmt.setString(2, multi.getParameter("content"));
						pstmt.setString(3, filename);
						pstmt.setInt(4, filesize);
						pstmt.setString(5, oriFilename);
						pstmt.setInt(6,Integer.parseInt(multi.getParameter("num")));
						flag = pstmt.executeUpdate();
					}
				}else {
					sql = "update tblgallery set subject = ?, content = ? where num=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, multi.getParameter("subject"));
					pstmt.setString(2, multi.getParameter("content"));
					pstmt.setInt(3,Integer.parseInt(multi.getParameter("num")));
				}
				flag = pstmt.executeUpdate();
			}
			
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	public boolean delGallery(int num) {
		boolean flag = false;
		String sql;
		
		try {
			sql = "select * from tblgallery where num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String filename = rs.getString("filename");
				String fileSrc = SAVEFOLDER+"/"+ filename;
				File file = new File(fileSrc);
				file.delete();
			}
			
			sql = "delete from tblgallery where num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			int exeCnt = pstmt.executeUpdate();
			if(exeCnt==1) flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
}
