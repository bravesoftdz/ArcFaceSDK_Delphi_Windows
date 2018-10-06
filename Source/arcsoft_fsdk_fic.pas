(* *******************************************************************************
  * C to Pascal by NJTZ 2018.9.20 eMail:yhdgs@qq.com
  ******************************************************************************** *)

unit arcsoft_fsdk_fic;

interface

uses
  Windows, Messages, SysUtils, Classes, amcomdef, asvloffscreenDef;

(* ******************************************************************************
  * Copyright(c) ArcSoft, All right reserved.
  *
  * This aFile is ArcSoft's property. It contains ArcSoft's trade secret, proprietary
  * and confidential information.
  *
  * DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT  ANY FORM WITHOUT PROPER
  * AUTHORIZATION.
  *
  * If you are not an intended recipient of this aFile, you must not copy,
  * distribute, modify, or take any action in reliance on it.
  *
  * If you have received this aFile in error, please immediately notify ArcSoft and
  * permanently delete the original and any copy of any aFile and any printout
  * thereof.
  ******************************************************************************** *)

const
  ArcFicDll = 'libarcsoft_fsdk_fic.dll';

type
  (* ******************************************************************************************
    * FIC �汾��Ϣ
    ****************************************************************************************** *)
  AFIC_FSDK_VERSION = record
    lCodebase: MInt32; // Codebase version number
    lMajor: MInt32; // Major version number
    lMinor: MInt32; // Minor version number
    lBuild: MInt32; // Build version number, increasable only
    Version: MPChar; // Version in string form
    BuildDate: MPChar; // Latest build Date
    CopyRight: MPChar; // Copyright
  end;

  LPAFIC_FSDK_VERSION = ^AFIC_FSDK_VERSION;

  (* ******************************************************************************************
    * FIC FT/FD�����������
    ****************************************************************************************** *)

  AFIC_FSDK_FACERES = record
    nFace: MInt32; // number of faces detected
    rcFace: MRECT; // IntPtr; // PMRECT; //The bounding box of face
  end;

  LPAFIC_FSDK_FACERES = ^AFIC_FSDK_FACERES;

  (* ***********************************************************************
    * ��ʼ������
    *********************************************************************** *)
function ArcSoft_FIC_InitialEngine(ID: MPChar; // [in] APPID
  SDKKEY: MPChar; // [in] SDKKEY
  var phFICEngine: MHandle // [out] FIC ����Handle��ָ��
  ): MRESULT; Cdecl; external ArcFicDll;

(* ***********************************************************************
  * ����������ȡ
  *********************************************************************** *)
function ArcSoft_FIC_FaceDataFeatureExtraction(hFICEngine: MHandle;
  // [in]  FIC ����Handle
  isVideo: MBool; // [in]  ������������ 1-��Ƶ 0-��̬ͼƬ
  pInputFaceData: LPASVLOFFSCREEN; // [in]  ����ͼ��ԭʼ����
  // pFaceRes: LPAFIC_FSDK_FACERES
  var FaceRes: AFIC_FSDK_FACERES // [out] �������� ������/������/�Ƕ�
  ): MRESULT; Cdecl; external ArcFicDll;

(* ***********************************************************************
  * ֤����������ȡ
  *********************************************************************** *)
function ArcSoft_FIC_IdCardDataFeatureExtraction(hFICEngine: MHandle;
  // [in]  FIC ����Handle
  pInputIdcardData: LPASVLOFFSCREEN // [in]  ͼ��ԭʼ����
  ): MRESULT; Cdecl; external ArcFicDll;

(* ***********************************************************************
  * ��֤�ȶ�
  *********************************************************************** *)
function ArcSoft_FIC_FaceIdCardCompare(hFICEngine: MHandle; // [in] FIC ����Handle
  threshold: MFloat; // [in]  �ȶ���ֵ
  var pSimilarScore: MFloat; // [out] �ȶԽ�����ƶ�
  var pResult: MInt32 // [out] �ȶԽ��
  ): MRESULT; Cdecl; external ArcFicDll;

(* ***********************************************************************
  * �ͷ�����
  *********************************************************************** *)
function ArcSoft_FIC_UninitialEngine(hFICEngine: MHandle // [in] FIC ����Handle
  ): MRESULT; Cdecl; external ArcFicDll;

(* ***********************************************************************
  * ��ȡ�汾��Ϣ
  *********************************************************************** *)
function ArcSoft_FIC_GetVersion(hFICEngine: MHandle): LPAFIC_FSDK_VERSION;
  Cdecl; external ArcFicDll;

implementation

end.
