package pack.member;


public class MemberLoginBean {
	private int num;
	private String uid;
	private int logincnt;
	private String loginip;
	private String logintm;
	private String conndev;
	
	public MemberLoginBean() {}
	public MemberLoginBean(int num, String uid, int logincnt, String loginip, String logintm, String conndev) {
		this.num = num;
		this.uid = uid;
		this.logincnt = logincnt;
		this.loginip = loginip;
		this.logintm = logintm;
		this.conndev = conndev;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public int getLogincnt() {
		return logincnt;
	}
	public void setLogincnt(int logincnt) {
		logincnt++;
		this.logincnt = logincnt;
	}
	public String getLoginip() {
		return loginip;
	}
	public void setLoginip(String loginip) {
		this.loginip = loginip;
	}
	public String getLogintm() {
		return logintm;
	}
	public void setLogintm(String logintm) {
		this.logintm = logintm;
	}
	public String getConndev() {
		return conndev;
	}
	public void setConndev(String conndev) {
		this.conndev = conndev;
	}
}
