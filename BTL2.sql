CREATE DATABASE BTL2

use BTL2;

------------------------------------
-- drop table NhomKH
CREATE TABLE NhomKH (
	Ma_Nhom int NOT NULL,
	Ten_Nhom varchar(20) NOT NULL,
	So_No_Min int default 0,
	So_No_Max int default 0,
	PRIMARY KEY (Ma_Nhom)
);
--DROP TABLE KhachHang
CREATE TABLE KhachHang (
  Ma_KH varchar(10) NOT NULL, 
  SDT varchar(10) NOT NULL,
  Ho_Va_Ten varchar(45) NOT NULL,
  DIACHI varchar(96) NOT NULL,
  Ma_Nhom int NOT NULL,
  No_Max int not null,
  So_No_Hien_Tai INT not null,
  PRIMARY KEY (Ma_KH),
  CONSTRAINT SDT_UNIQUE UNIQUE(SDT), 
  CONSTRAINT fk_Ma_Nhom_KH2 FOREIGN KEY (Ma_Nhom) REFERENCES NhomKH(Ma_Nhom)
);

-- DROP TABLE DonHang
CREATE TABLE DonHang (
  Ma_DH varchar(10) NOT NULL,
  Ma_KH varchar(10) NOT NULL,
  Nguoi_Tao_Don varchar(45) NOT NULL,
  Ngay_Tao_Don time default GETDATE(),
  Note varchar(200),
  PRIMARY KEY (Ma_DH),
  CONSTRAINT fk_Ma_KH1 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH)
);

--DROP TABLE HangHoa

CREATE TABLE HangHoa (
	Ma_HH varchar(10) NOT NULL UNIQUE,
	Ten varchar(20) NOT NULL,
	Mo_Ta_Chi_Tiet varchar(200),
	Link_Anh_sp varchar(200),
	Nha_Cung_Cap varchar(20) NOT NULL,
	So_Luong_Ton_Kho int default 10,
	Mau_Sac varchar(10),
	Qui_Cach varchar(200),
	Loai_Hang varchar(10),
	Gia int NOT NULL,
	PRIMARY KEY (Ma_HH)
);



CREATE TABLE PhieuThuChi (
	Ma_Phieu varchar(10) NOT NULL,
	PRIMARY KEY(Ma_Phieu),
	Loai varchar(10) NOT NULL CHECK (Loai IN('Thu', 'Chi')),
	Tien int NOT NULL,
	Ngay TIME default GETDATE(),
	Ma_KH varchar(10) NOT NULL UNIQUE,
	CONSTRAINT fk_Ma_KH2 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	NOTE varchar(200)
);

CREATE TABLE HoaDon (
	Ma_HD varchar(10) NOT NULL,
	PRIMARY KEY (Ma_HD),
	Ma_KH varchar(10) NOT NULL,
	Ma_DH varchar(10) NOT NULL,
	Don_Gia int NOT NULL,
	VAT int NOT NULL default 8,
	Ngay TIME default GETDATE(),
	Trang_Thai varchar(40) NOT NULL CHECK (Trang_Thai IN('Cho', 'Dang_Xu_Ly','Hoan_Thanh','Huy'))
	CONSTRAINT fk_Ma_KH3 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	CONSTRAINT fk_Ma_DH1 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE TienTrinh (
	PID varchar(10) NOT NULL UNIQUE,
	PRIMARY KEY (PID),
	Ngay TIME NOT NULL,
	Ma_HD varchar(10) NOT NULL,
	CONSTRAINT fk_Ma_HD1 FOREIGN KEY (Ma_HD) REFERENCES HoaDon(Ma_HD),
	Trang_Thai varchar(40) NOT NULL CHECK (Trang_Thai IN('Cho', 'Dang_Xu_Ly','Hoan_Thanh','Huy'))
);

CREATE TABLE NhanVien (
	EID varchar(10) NOT NULL UNIQUE,
	Ho_Va_Ten varchar(45) NOT NULL,
	Vai_Tro varchar(40) NOT NULL CHECK (Vai_Tro
	IN('QLGH', 'TX','XK','QL','NVLD','KT','TN','NVBH')),
	PRIMARY KEY(EID)
);

CREATE TABLE ChuyenHang (
	Ma_Chuyen varchar(10) NOT NULL UNIQUE,
	PRIMARY KEY (Ma_Chuyen)
);

CREATE TABLE TinhTrangChuyen (
	Ma_Chuyen varchar(10),
	[Date] TIME NOT NULL DEFAULT GETDATE(),
	Trang_Thai varchar(40) NOT NULL CHECK (Trang_Thai IN('Cho_Khoi_Hanh', 'Da_Khoi_Hanh','Da_Hoan_Thanh')),
	CONSTRAINT fk_Ma_Chuyen1 FOREIGN KEY (Ma_Chuyen) REFERENCES ChuyenHang(Ma_Chuyen),
	PRIMARY KEY (Ma_Chuyen)
);

CREATE TABLE DonViVanChuyen (
	Ma_VC int NOT NULL unique,
	Phuong_Tien varchar(40) NOT NULL CHECK (Phuong_Tien IN('Xe_may', 'Oto')),
	Loai varchar(40) NOT NULL CHECK (Loai IN('Insource', 'Outsource')),
	PRIMARY KEY (Ma_VC)
);

CREATE TABLE VanChuyenNgoai (
	Ma_VC int NOT NULL UNIQUE,
	IDM varchar(10) NOT NULL UNIQUE,
	IDD varchar(10) NOT NULL UNIQUE,
	Ten varchar(40),
	PRIMARY KEY (Ma_VC),
	CONSTRAINT fk_IDM3 FOREIGN KEY (IDM) REFERENCES DonHang(Ma_DH),
	CONSTRAINT fk_Ma_VC1 FOREIGN KEY (Ma_VC) REFERENCES DonViVanChuyen(Ma_VC)
);

CREATE TABLE VanChuyenCty (
	Ma_VC int NOT NULL UNIQUE,
	IDM varchar(10) NOT NULL UNIQUE,
	IDD varchar(10) NOT NULL UNIQUE,
	PRIMARY KEY (Ma_VC),
	CONSTRAINT fk_Ma_VC2 FOREIGN KEY (Ma_VC) REFERENCES DonViVanChuyen(Ma_VC),
	CONSTRAINT fk_IDM2 FOREIGN KEY (IDM) REFERENCES DonHang(Ma_DH),
	CONSTRAINT fk_IDD2 FOREIGN KEY (IDD) REFERENCES NhanVien(EID)
);

------------------------------------------------------------
--CREATE RELATION 

CREATE TABLE ThuocNhom (
	Ma_Nhom int NOT NULL UNIQUE,
	Ma_KH varchar(10) NOT NULL UNIQUE,
	Ten_Nhom varchar(20) NOT NULL,
	PRIMARY KEY (Ma_Nhom),
	CONSTRAINT fk_Ma_KH4 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	CONSTRAINT fk_Ma_Nhom FOREIGN KEY (Ma_Nhom) REFERENCES NhomKH(Ma_Nhom)
	--CONSTRAINT fk_Ten_Nhom FOREIGN KEY (Ten_Nhom) REFERENCES NhomKH(Ten_Nhom)
);

CREATE TABLE ThuChi (
	Ma_Phieu varchar(10) NOT NULL,
	EID varchar(10) NOT NULL,
	PRIMARY KEY (Ma_Phieu),
	CONSTRAINT fk_EID1 FOREIGN KEY (EID) REFERENCES NhanVien(EID),
	CONSTRAINT fk_Ma_Phieu FOREIGN KEY (Ma_Phieu) REFERENCES PhieuThuChi(Ma_Phieu)
);

CREATE TABLE NhanVienTao (
	EID varchar(10) NOT NULL,
	Ma_DH varchar(10) NOT NULL,
	PRIMARY KEY (Ma_DH),
	CONSTRAINT fk_EID2 FOREIGN KEY (EID) REFERENCES NhanVien(EID),
	CONSTRAINT fk_Ma_DH FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE XuatBan (
	EID varchar(10) NOT NULL,
	Ma_DH varchar(10) NOT NULL,
	PRIMARY KEY (Ma_DH),
	CONSTRAINT fk_EID3 FOREIGN KEY (EID) REFERENCES NhanVien(EID),
	CONSTRAINT fk_Ma_DH2 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE KHTao (
	Ma_DH varchar(10) NOT NULL,
	PRIMARY KEY(Ma_DH),
	Ma_KH varchar(10) NOT NULL UNIQUE,
	CONSTRAINT fk_Ma_KH5 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	CONSTRAINT fk_Ma_DH3 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE BaoGom (
	Ma_DH varchar(10) NOT NULL,
	Ma_HH varchar(10),
	PRIMARY KEY (Ma_DH,Ma_HH),
	CONSTRAINT fk_Ma_DH4 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH),
	CONSTRAINT fk_Ma_HH1 FOREIGN KEY (Ma_HH) REFERENCES HangHoa(Ma_HH)
);

CREATE TABLE XuLy (
	PID varchar(10) NOT NULL UNIQUE,
	PRIMARY KEY (PID),
	Ma_HD varchar(10) NOT NULL,
	CONSTRAINT fk_Ma_HD2 FOREIGN KEY (Ma_HD) REFERENCES HoaDon(Ma_HD),
	CONSTRAINT fk_PID1 FOREIGN KEY (PID) REFERENCES TienTrinh(PID)
);

CREATE TABLE VanChuyen (
	Ma_VC int NOT NULL unique,
	Ma_Chuyen varchar(10) NOT NULL UNIQUE,
	PRIMARY KEY(Ma_VC),
	CONSTRAINT fk_Ma_Chuyen5 FOREIGN KEY (Ma_Chuyen) REFERENCES ChuyenHang(Ma_Chuyen),
	CONSTRAINT fk_Ma_VC3 FOREIGN KEY (Ma_VC) REFERENCES DonViVanChuyen(Ma_VC)
);

CREATE TABLE GomKienHang (
	Ma_Chuyen varchar(10) NOT NULL UNIQUE,
	Ma_HD varchar(10) NOT NULL,
	Ma_HH varchar(10),
	Can_Nang int NOT NULL,
	Noi_Den varchar(20) NOT NULL,
	So_Luong int NOT NULL,
	CONSTRAINT fk_Ma_HD3 FOREIGN KEY (Ma_HD) REFERENCES HoaDon(Ma_HD),
	CONSTRAINT fk_Ma_Chuyen6 FOREIGN KEY (Ma_Chuyen) REFERENCES ChuyenHang(Ma_Chuyen),
	CONSTRAINT fk_Ma_HH2 FOREIGN KEY (Ma_HH) REFERENCES HangHoa(Ma_HH),
	PRIMARY KEY (Ma_Chuyen,Ma_HD,Ma_HH)
);

--------------------------------------------

-- INSERT NhomKH
SELECT * FROM NhomKH

INSERT INTO NhomKH VALUES (1001, 'NHOM_1', 0, 1000000);
INSERT INTO NhomKH VALUES (1002, 'NHOM_2', 1000000, 5000000);
INSERT INTO NhomKH VALUES (1003, 'NHOM_3', 5000000, 20000000);
INSERT INTO NhomKH VALUES (1004, 'NHOM_4', 20000000, NULL);

--INSERT TABLE KHachHang
SELECT * FROM KhachHang
DELETE KhachHang
INSERT INTO KhachHang VALUES ('KH_00001', 0849434447,'Nguyen Manh Thuyen','28 Lac Long Quan, TT Quang Phu, Huyen Cumgar, Tinh Daklak',1001,1000000,312424);
INSERT INTO KhachHang VALUES ('KH_00002',0986941029,'Nguyen Van A','12 Phan Van Tri, Quan Go Vap, TP HCM',1002,5000000,2124124);
INSERT INTO KhachHang VALUES ('KH_00003',0947284932,'Nguyen Thi B','108 Mai Chi Tho, Quan Binh Thanh, TP HCM',1001,1000000,345544);
INSERT INTO KhachHang VALUES ('KH_00004',0926185736,'Nguyen Van C','54 Tran Xuan Soan, Quan 7, TP HCM',1003,25000000,32076456);
INSERT INTO KhachHang VALUES ('KH_00005',0992837465,'Nguyen Van D','277 Nam Ky Khoi Nghia, Quan 3, TP HCM',1002,20000000);

-- INSERT TABLE DonHang
SELECT * FROM DonHang
INSERT INTO DonHang VALUES ('DH_00001','KH_00005','Nguyen Van D',GETDATE(),'Hang de vo');
INSERT INTO DonHang VALUES ('DH_00002','KH_00005','Nguyen Van D',GETDATE(),'Giao hang nhanh giup em a :<');
INSERT INTO DonHang VALUES ('DH_00003','KH_00005','Nguyen Van D',GETDATE(),'Shop dong goi ky giup em');
INSERT INTO DonHang VALUES ('DH_00004','KH_00003','Nguyen Thi B',GETDATE(),NULL);
INSERT INTO DonHang VALUES ('DH_00005','KH_00002','Nguyen Van A',GETDATE(),'Shop check hang ky giup em nha');


--INSERT TABLE HangHoa
SELECT * FROM HangHoa

INSERT INTO HangHoa VALUES ('V_01', 'Kate','thoang mat, de chiu', NULL, 'Hao Hao', 15,'Trang', NULL, 'tong hop', 50000);
INSERT INTO HangHoa VALUES ('V_02', 'Linen Caro','tham hut mo hoi tot', NULL, 'Ba mien', 24,'Trang-Nau', NULL, 'tu nhien', 80000);
INSERT INTO HangHoa VALUES ('V_03', 'Lua','mem, min, ben, chac chan', NULL, 'Kokomi', 26,'Do', NULL, 'tu nhien', 150000);
INSERT INTO HangHoa VALUES ('V_04', 'Canvas-cotton','ben, giu mau tot', NULL, 'Omachi', 15,'Xam', NULL, 'tong hop', 55000);
INSERT INTO HangHoa VALUES ('V_05', 'Voan','mem, mout, thoang mat', NULL, 'Cung dinh', 15,'Xanh', NULL, 'tong hop', 70000);

-- INSERT PHIEU THU CHI
SELECT* FROM PhieuThuChi
DELETE PhieuThuChi
INSERT INTO PhieuThuChi VALUES (2001, 'Thu', 1000000, GETDATE(), 'KH_00005', 'thu tien');
INSERT INTO PhieuThuChi VALUES (2002, 'Thu', 500000, GETDATE(), 'KH_00003', 'thu tien');
INSERT INTO PhieuThuChi VALUES (2003, 'Thu', 1000000, GETDATE(), 'KH_00002', NULL);


-- INSERT nhan vien
SELECT* FROM NhanVien

INSERT INTO NhanVien VALUES ('NV_00001', 'Pham Thanh Tu', 'QLGH');
INSERT INTO NhanVien VALUES ('NV_00002', 'Dang Van Bi', 'TX');
INSERT INTO NhanVien VALUES ('NV_00003', 'Ly Tieu Long', 'XK');
INSERT INTO NhanVien VALUES ('NV_00004', 'Tran Thanh Binh', 'QL');
INSERT INTO NhanVien VALUES ('NV_00005', 'Nguyen Nga', 'NVLD');
INSERT INTO NhanVien VALUES ('NV_00006', 'Ho Thi Thu', 'KT');
INSERT INTO NhanVien VALUES ('NV_00007', 'Le Thuy Trang', 'TN');
INSERT INTO NhanVien VALUES ('NV_00008', 'Nguyen Thuat', 'NVBH');
INSERT INTO NhanVien VALUES ('NV_00009', 'Nguyen Thu', 'TX');
INSERT INTO NhanVien VALUES ('NV_00010', 'Tran Dai Nghia', 'TX');

-- INSERT chuyen hang
SELECT* FROM ChuyenHang

INSERT INTO ChuyenHang VALUES ('CH_0001');
INSERT INTO ChuyenHang VALUES ('CH_0002');
INSERT INTO ChuyenHang VALUES ('CH_0003');
INSERT INTO ChuyenHang VALUES ('CH_0004');
INSERT INTO ChuyenHang VALUES ('CH_0005');

-- INSERT Tinh trang chuyen
SELECT* FROM TinhTrangChuyen

INSERT INTO TinhTrangChuyen VALUES ('CH_0001', GETDATE(), 'Cho_Khoi_Hanh');
INSERT INTO TinhTrangChuyen VALUES ('CH_0002', GETDATE(), 'Da_Khoi_Hanh');
INSERT INTO TinhTrangChuyen VALUES ('CH_0003', GETDATE(), 'Da_Khoi_Hanh');
INSERT INTO TinhTrangChuyen VALUES ('CH_0004', GETDATE(), 'Da_Khoi_Hanh');
INSERT INTO TinhTrangChuyen VALUES ('CH_0005', GETDATE(), 'Da_Hoan_Thanh');

-- INSERT Don vi van chuyen
SELECT* FROM DonViVanChuyen

INSERT INTO DonViVanChuyen VALUES (3001, 'Xe_may', 'Insource');
INSERT INTO DonViVanChuyen VALUES (3002, 'Xe_may', 'Outsource');
INSERT INTO DonViVanChuyen VALUES (3003, 'Xe_may', 'Insource');
INSERT INTO DonViVanChuyen VALUES (3004, 'Oto', 'Outsource');
INSERT INTO DonViVanChuyen VALUES (3005, 'Oto', 'Insource');


-- INSERT Hoa don
SELECT* FROM HoaDon

INSERT INTO HoaDon VALUES ('HD_0001', 'KH_00005', 'DH_00001',500000, 8, GETDATE(), 'Cho');
INSERT INTO HoaDon VALUES ('HD_0002', 'KH_00005', 'DH_00002', 497000,8, GETDATE(), 'Cho');
INSERT INTO HoaDon VALUES ('HD_0003', 'KH_00005', 'DH_00003', 10200000, 8, GETDATE(), 'Dang_Xu_Ly');
INSERT INTO HoaDon VALUES ('HD_0004', 'KH_00003', 'DH_00004', 1500000, 8, GETDATE(), 'Hoan_Thanh');
INSERT INTO HoaDon VALUES ('HD_0005', 'KH_00002', 'DH_00005', 250000, 8, GETDATE(), 'Huy');


-- INSERT VanChuyenCty
SELECT* FROM DonViVanChuyen
SELECT* FROM NhanVien
SELECT* FROM DonHang
SELECT* FROM VanChuyenCty

INSERT INTO VanChuyenCty VALUES (3001,'DH_00002','NV_00010');
INSERT INTO VanChuyenCty VALUES (3003,'DH_00001','NV_00002');
INSERT INTO VanChuyenCty VALUES (3005,'DH_00003','NV_00009');

-- INSERT VAn chuyen ngoai
SELECT* FROM VanChuyenNgoai

INSERT INTO VanChuyenNgoai VALUES (3002, 'DH_00004', '241828437','Nguyen Manh Dung');
INSERT INTO VanChuyenNgoai VALUES (3004, 'DH_00005', '298790870','Nguyen Tien Hai');


--SELECT * FROM DonHang inner join KhachHang on DonHang.Ma_KH = KhachHang.Ma_KH

--INSERT TABLE HangHoa

-------------------------------------------------
--2.1 Thu Tuc INSERT UPDATE DROP dbo.KhachHang
go
CREATE PROCEDURE checkNMT ( @Ma_KH INT,
							@SDT VARCHAR(10),
						    @Ho_Va_Ten  VARCHAR(45),
					        @DIACHI  VARCHAR(96),
					        @StatementType NVARCHAR(20) = '')
AS
  BEGIN
      IF @StatementType = 'Insert'
        BEGIN
            INSERT INTO KhachHang   (Ma_KH,SDT,Ho_Va_Ten,DIACHI)
            VALUES     (@Ma_KH,@SDT,@Ho_Va_Ten,@DIACHI)
        END

      IF @StatementType = 'Select'
        BEGIN
            SELECT *
            FROM   KhachHang
        END

      IF @StatementType = 'Update'
        BEGIN
            UPDATE KhachHang
            SET    SDT = @SDT,
                   Ho_Va_Ten = @Ho_Va_Ten,
                   DIACHI=@DIACHI
            WHERE  Ma_KH=@Ma_KH
        END
      ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM KhachHang
            WHERE  Ma_KH = @Ma_KH
        END
  END
  GO
  -------------------------------------

--2.2 Trigger
CREATE TRIGGER trg_NhomKH
	ON NhomKH
	AFTER  UPDATE,INSERT,DELETE
AS BEGIN
	DECLARE @Ma_Nhom int
	DECLARE @Ten_Nhom varchar(20)
	-- TEMP TABLE
	;WITH TMP AS (
		SELECT Ma_Nhom FROM inserted
		UNION
		SELECT Ma_Nhom FROM deleted
	)
	SELECT @Ma_Nhom = Ma_Nhom FROM TMP
	UPDATE ThuocNhom 
	SET Ten_Nhom = @Ten_Nhom
	WHERE Ma_Nhom = @Ma_Nhom
END
go
--------------------------------
CREATE TRIGGER trg_CapNhatSoLuongHangHoa
	ON GomKienHang
	AFTER INSERT
AS BEGIN 
	DECLARE @Ma_HH int
	DECLARE @So_Luong_Mua int
	SELECT @Ma_HH = Ma_HH ,  @So_Luong_Mua = So_Luong FROM inserted

	-- Cap Nhap So Luong Ton Kho
	UPDATE HangHoa
	SET So_Luong_Ton_Kho = So_Luong_Ton_Kho - @So_Luong_Mua
	WHERE Ma_HH = @Ma_HH
END
go
--------------------------------
--2.3 
CREATE PROCEDURE Loc_KH_Co_Tren_0_DH_GiamDan1
AS
SELECT Ho_Va_Ten,SDT,count(*) as 'So don da dat' FROM DonHang as  d inner join KhachHang as k on d.Ma_KH = k.Ma_KH
GROUP BY k.Ho_Va_Ten,SDT
having count(*) > 0
order by count(*) DESC

EXEC Loc_KH_Co_Tren_0_DH_GiamDan1
