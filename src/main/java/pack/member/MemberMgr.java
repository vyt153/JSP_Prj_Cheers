package pack.member;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import pack.dbcp.DBConnectionMgr;

public class MemberMgr {
	Connection conn;
	Statement stmt;
	ResultSet rs;
	ResultSetMetaData rsmd;
	PreparedStatement pstmt;
	DBConnectionMgr pool;

	public MemberMgr() { //DB 접속
		try {
			pool = DBConnectionMgr.getInstance();
			conn = pool.getConnection();		
		} catch (Exception e) {
			System.out.println("exception : " +e.getMessage());
		}
		
		System.out.println("DB Access OK!!");
	}
	
	// 아이디 중복검사 시작 (/member/idCheck.jsp)
	public boolean checkId(String uid) {
		boolean res = false;
		
		String sql = "select count(*) from member where uid = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				int recordCnt = rs.getInt(1);
				if(recordCnt==1) res = true;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	// 아이디 중복검사 끝 (/member/idCheck.jsp)
	
	// 우편번호 찾기(/member/zipCheck.jsp
	public List<ZipcodeBean> zipcodeRead(String area3){
		List<ZipcodeBean> list = new Vector<>();
		try {
			String sql = "select zipcode, area1, area2, area3, area4";
			sql += " from tblZipcode where area3 like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,"%"+ area3+"%");
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ZipcodeBean zipBean = new ZipcodeBean();
				zipBean.setZipcode(rs.getString(1));
				zipBean.setArea1(rs.getString(2));
				zipBean.setArea2(rs.getString(3));
				zipBean.setArea3(rs.getString(4));
				zipBean.setArea4(rs.getString(5));
				
				list.add(zipBean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt, rs);
		}
		return list;
	}
	// 우편번호 찾기 끝
	
	// 회원가입 시작(/member/memberProc.jsp)
	public boolean insertMember(MemberBean bean) {
		boolean flag = false;
		
		String sql = "insert into member(";
		sql += "uid, upw, uname, uemail, gender, ubirthday,";
		sql += "uzipcode, uaddr, uhobby, ujob, joinTm)";
		sql += "values(?,?,?,?,?,?,?,?,?,?, now())";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getUid());
			pstmt.setString(2, bean.getUpw());
			pstmt.setString(3, bean.getUname());
			pstmt.setString(4, bean.getUemail());
			pstmt.setString(5, bean.getGender());
			pstmt.setString(6, bean.getUbirthday());
			pstmt.setString(7, bean.getUzipcode());
			pstmt.setString(8, bean.getUaddr());
			
			String[] hobby = bean.getUhobby();
			String[] hobbyName = {"인터넷","여행","게임","영화","운동"};
			char[] hobbyCode = {'0','0','0','0','0'};
			if(hobby!=null) {
				for (int i = 0; i < hobby.length; i++) {
					for (int j = 0; j < hobbyName.length; j++) {
						if(hobby[i].equals(hobbyName[j])) {
							hobbyCode[j]='1';
						}
					}
				}
			}
			pstmt.setString(9, new String(hobbyCode));
			
			pstmt.setString(10, bean.getUjob());
			int rowCnt = pstmt.executeUpdate();
			
			if(rowCnt==1) flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt);
		}
		
		return flag;
	}
	// 회원가입 끝(/member/memberProc.jsp)
	
	// 로그인 처리 시작(/member/loginProc.jsp)
	public boolean loginMember(String uid, String upw) {
		boolean loginChkTF = false;
		
		String sql = "select count(*) from member where uid = ? and upw = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			pstmt.setString(2, upw);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				int recordCnt = rs.getInt(1);
				if(recordCnt==1) loginChkTF = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(conn, pstmt, rs);
		}
		return loginChkTF;
	}
	// 로그인 처리 끝(/member/loginProc.jsp)
	
	// 회원정보 수정 입력양식 시작(/member/memberMod.jsp
	public MemberBean modifyMember(String uid) {
		MemberBean mBean = new MemberBean();
		// Statement => 매개변수가 없을 경우
		// PreparedStatement => 매개변수가 있을 경우
		
		String sql = "select * from member where uid= ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				mBean.setUid(rs.getString("uid"));
				mBean.setUpw(rs.getString("upw"));
				mBean.setUname(rs.getString("uname"));
				mBean.setUemail(rs.getString("uemail"));
				mBean.setGender(rs.getString("gender"));
				mBean.setUbirthday(rs.getString("ubirthday"));
				mBean.setUzipcode(rs.getString("uzipcode"));
				mBean.setUaddr(rs.getString("uaddr"));
				String[] hobbyArr = new String[5];
				String hobby = rs.getString("uhobby");
				
				hobbyArr = hobby.split("");
				mBean.setUhobby(hobbyArr);
				mBean.setUjob(rs.getString("ujob"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return mBean;
	}
	// 회원정보 수정 입력양식 끝(/member/memberMod.jsp)
	
	// 회원정보 수정 시작(/member/memberModProc.jsp)
	public boolean modifyMemberProc(MemberBean bean) {
		boolean modRes = false;
		
		String sql = "update member set uname=?, uemail=?, ";
		sql += " gender=?, ubirthday=?, uzipcode=?, uaddr=?, ";
		sql += " uhobby=?, ujob=? where uid=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getUname());
			pstmt.setString(2, bean.getUemail());
			pstmt.setString(3, bean.getGender());
			pstmt.setString(4, bean.getUbirthday());
			pstmt.setString(5, bean.getUzipcode());
			pstmt.setString(6, bean.getUaddr());
			String[] hobby = bean.getUhobby();
			String[] hobbyName = {"인터넷","여행","게임","영화","운동"};
			char[] hobbyCode = {'0','0','0','0','0'};
			if(hobby!=null) {
				for (int i = 0; i < hobby.length; i++) {
					for (int j = 0; j < hobbyName.length; j++) {
						if(hobby[i].equals(hobbyName[j])) {
							hobbyCode[j]='1';
						}
					}
				}
			}
			pstmt.setString(7, new String(hobbyCode));
			pstmt.setString(8, bean.getUjob());
			pstmt.setString(9, bean.getUid());
			
			int modCnt = pstmt.executeUpdate();
			if(modCnt==1) modRes = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return modRes;
	}
	// 회원정보 수정 끝(/member/memberModProc.jsp)
	
	// 비밀번호 수정 시작
public boolean modifyPw(String pw, String newPw, String uid) {
		int updateChk = 0;
		boolean flag= false;
		String sql = "update member set upw = ? where uid= ? and upw= ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, newPw);
			pstmt.setString(2, uid);
			pstmt.setString(3, pw);
			updateChk = pstmt.executeUpdate();
			if(updateChk==1) flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	// 비밀번호 수정 끝

//회원 탈퇴 시작(/member/memberQuitProc.jsp)
	public boolean memberQuit(String uid, String upw) {
		boolean flag = false;
		String sql = "delete from loginInfo where uid = ?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			pstmt.execute();

			sql = "delete from member where uid=? and upw=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			pstmt.setString(2, upw);
			int exeCnt = pstmt.executeUpdate();
			if(exeCnt==1) flag=true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}

	// 회원 탈퇴 끝(/member/memberQuitProc.jsp)

	// 탈퇴 시 게시판 글 삭제 시작
	public boolean delTbl(String uid) {
		boolean flag = false;
		String sql;
		int exeCnt = 0;
		ResultSet rs2;
		try {
			sql = "select * from tblboard where uid = '"+uid+"'";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				int ref = rs.getInt("ref");
				int pos = rs.getInt("pos");
				int num = rs.getInt("num");
				String uname = rs.getString("uname");
				int unCnt = 0;
				
				sql = "select count(distinct uname) as unameCnt from tblboard where ref=? and pos>=? and num>=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, pos);
				pstmt.setInt(3, num);
				rs2 = pstmt.executeQuery();
				
				if(rs2.next()) {
					unCnt = rs2.getInt(1);
				}
				if(unCnt >= 2) {
					
					sql = "delete from tblboard where ref=? and pos>? and uname=? and num>?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					pstmt.setInt(2, pos);
					pstmt.setString(3, uname);
					pstmt.setInt(4, num);
					exeCnt = pstmt.executeUpdate();
					
					sql = "update tblboard set uname=?, subject=?, content=?, readcnt=?, ";
					sql += "uid=? where num=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, "관리자");
					pstmt.setString(2, "삭제된 게시물 입니다.");
					pstmt.setString(3, "삭제된 게시물 입니다.");
					pstmt.setInt(4, 0);
					pstmt.setString(5, "-");
					pstmt.setInt(6, num);
					pstmt.execute();
				} else {
					sql = "delete from tblboard where ref=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					exeCnt = pstmt.executeUpdate();
				}
			
			}

			sql = "delete from tblgallery where uid = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			exeCnt = pstmt.executeUpdate();
			if(exeCnt==1) flag=true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	// 탈퇴 시 게시판 글 삭제 끝
	
	// 탈퇴 시 파일 삭제 시작
	public void delFile(String uid) {
		String sql;
		String path;
		
		try {
			sql = "select * from tblboard where uid ='"+uid+"'";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			path = "D:/AJR_20230126/Hong/silsp/p08_JSP/cheers_0420/src/main/webapp/fileupload";
			while(rs.next()) {
				if(rs.getString("filename")!=null) {
					String fName = rs.getString("filename");
					String fileSrc = path + "/" + fName;
					File file = new File(fileSrc);
					
					if(file.exists()) file.delete();
				}
			}
			sql = "select * from tblgallery where uid ='"+uid+"'";
			pstmt = conn.prepareStatement(sql);
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			path = "D:/AJR_20230126/Hong/silsp/p08_JSP/cheers_0420/src/main/webapp/galleryupload";
			while(rs.next()) {
				if(rs.getString("filename")!=null) {
					String fName = rs.getString("filename");
					String fileSrc = path + "/" + fName;
					File file = new File(fileSrc);
					
					if(file.exists()) file.delete();
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	// 탈퇴 시 파일 삭제 끝
	
	// 로그인 사용자 이름 반환(/bbs/write.jsp) 시작
	public String getMemberName(String uid) {
		String uname="";
		String sql = "select uname from member where uid=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				uname = rs.getNString(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return uname;
	}
	// 로그인 사용자 이름 반환(/bbs/write.jsp) 끝
	
	// 접속내역 입력(/member/loginProc) 시작
	public boolean memberInsertLogin(MemberLoginBean bean, int loginCnt){
		
		boolean flag = false;
		String sql = "insert into loginInfo (uid, logincnt, loginip) ";
		sql += "values(?,?,?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getUid());
			pstmt.setInt(2, loginCnt);
			pstmt.setString(3, bean.getLoginip());
			int rowCnt = pstmt.executeUpdate();
			if(rowCnt==1) flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
	// 접속내역 입력(/member/loginProc) 끝
	
	// 접속횟수 구하기(/member/loginProc) 시작
	public int memberLoginCnt(String Uid){
		int loginCnt = 0;
		String sql = "select count(*) as cnt from loginInfo where uid='"+Uid+"'";
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if(rs.next()) loginCnt = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return loginCnt;
	}
	// 접속횟수 구하기(/member/loginProc) 끝
	
	// 접속내역 출력(/member/mypageAccessList) 시작
	public List<MemberLoginBean> memberLogin(String Uid){
		List<MemberLoginBean> list = new ArrayList<MemberLoginBean>();
		String sql = "select * from loginInfo where uid='"+Uid+"' order by num desc";
		try {
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy/MM/dd E a HH:mm");
			while(rs.next()) {
				int num = rs.getInt("num");
				String uid = rs.getString("uid");
				int loginCnt = rs.getInt("logincnt");
				String loginip = rs.getString("loginip");
				Timestamp date = rs.getTimestamp("logintm");
				String loginTM = dateFormatter.format(date);
				String conndev = rs.getString("conndev");
				
				MemberLoginBean loginBean = new MemberLoginBean(num, uid, loginCnt, loginip, loginTM, conndev);
				list.add(loginBean);
			}
						
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	// 접속내역 출력(/member/mypageAccessList) 끝
	
	// 아이디 찾기(/findId) 시작
	public String findId(MemberBean bean) {
		String uid = "";
		String sql;
		
		try {
			sql = "select uid from member where uname = ? and ubirthday = ?";
			sql += " and uemail = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getUname());
			pstmt.setString(2, bean.getUbirthday());
			pstmt.setString(3, bean.getUemail());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				uid = rs.getString(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return uid;
	}
	public String findPw(MemberBean bean) {
		String upw = "";
		String sql;
		
		try {
			sql = "select upw from member where uname = ? and uid = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getUname());
			pstmt.setString(2, bean.getUid());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				upw = rs.getString(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return upw;
	}
}
