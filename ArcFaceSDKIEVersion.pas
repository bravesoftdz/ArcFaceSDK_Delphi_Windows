(* ******************************************************
  * ��������ʶ��SDK��װ ImageEN ��
  * ��Ȩ���� (C) 2017 NJTZ  eMail:yhdgs@qq.com
  ****************************************************** *)
{$INCLUDE ARCFACE.INC}
unit ArcFaceSDKIEVersion;

interface

uses Windows, Messages, SysUtils, System.Classes, amcomdef, ammemDef,
  arcsoft_fsdk_face_detection,
  arcsoft_fsdk_face_recognition,
  arcsoft_fsdk_face_tracking, asvloffscreendef, merrorDef,
  arcsoft_fsdk_age_estimation, arcsoft_fsdk_gender_estimation,
  Vcl.Graphics, Vcl.Imaging.jpeg, System.Generics.Collections, ArcFaceSDK,
  hyieutils, hyiedefs, imageenio, imageenproc, imageenview, iexBitmaps,
  System.Math {$IFDEF ARC_RZ_SDK}, arcsoft_fsdk_fic{$ENDIF};

type

  TResampleOptions = record
    NewWidth: Integer;
    NewHeight: Integer;
    Filter: TResampleFilter;
  end;

  TArcFaceSDKIEVersion = class(TArcFaceSDK)
  private
    FContrastRatio: Double;
    FResampleFilter: TResampleFilter;
    FResampleHeight: Integer;
    FResampleWidth: Integer;
    FImgDataInfoCache: TImgdataInfo;
  public
    constructor Create;
    destructor Destroy; override;
    class function CropFace(ASouceIEBitmap, ADestBitmap: TIEBitmap; AFaceRegion:
      AFR_FSDK_FACEINPUT; AExtendRatio, AResampleWidth, AResampleHeight: Integer;
      AResampleFilter: TResampleFilter): Boolean;
    function DetectAndRecognitionFacesFromIEBitmap(ABitmap: TIEBitmap; var
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels;
      AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
      AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean):
      Boolean; overload;
    function DetectAndRecognitionFacesFromIEBitmap(ABitmap: TIEBitmap; var
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels;
      AOutIEBitmp: TIEBitmap; AUseCache: Boolean): Boolean; overload;
    function DetectAndRecognitionFacesFromBitmapEX(ABitmap: TBitmap; var
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels;
      AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
      AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean):
      Boolean; overload;
    function DetectFacesAndAgeGenderFromBitmapEX(ABitmap: TBitmap;
      var AFaceInfos:
      TList<TFaceBaseInfo>; AOutIEBitmp: TIEBitmap; AResampleWidth,
      AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
      Double; AUseCache: Boolean): Boolean; overload;
    function DetectAndRecognitionFacesFromFileEx(AFileName: string; var
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels;
      AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
      AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean):
      Boolean; overload;
    function DRAGfromIEBitmap(ABitmap: TIEBitmap; var AFaceInfos:
      TList<TFaceBaseInfo>; var AFaceModels: TFaceModels; AOutIEBitmp: TIEBitmap;
      AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter;
      AContrast: Double; AUseCache: Boolean): Boolean; overload;
    function DetectFacesAndAgeGenderFromIEBitmap(ABitmap: TIEBitmap; var
      AFaceInfos: TList<TFaceBaseInfo>; AOutIEBitmp: TIEBitmap; AUseCache:
      Boolean): Boolean; overload;
    function DetectFacesAndAgeGenderFromFileEx(AFileName: string; var AFaceInfos:
      TList<TFaceBaseInfo>; AOutIEBitmp: TIEBitmap; AResampleWidth,
      AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
      Double; AUseCache: Boolean): Boolean; overload;
    function DetectFacesFromIEBitmap(ABitmap: TIEBitmap; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; AOutIEBitmp: TIEBitmap; AResampleWidth,
      AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
      Double; AUseCache: Boolean): Boolean; overload;
    function DetectFacesFromFile(AFile: string; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; AOutIEBitmp: TIEBitmap; AResampleWidth,
      AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
      Double; AUseCache: Boolean): Boolean; overload;
    function DetectFacesFromFile(AFile: string; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; AOutIEBitmp: TIEBitmap; AUseCache: Boolean):
      Boolean; overload;
    function DetectFacesFromIEBitmap(ABitmap: TIEBitmap; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; AOutIEBitmp: TIEBitmap; AUseCache: Boolean):
      Boolean; overload;
    class procedure DrawFaceRectAgeGenderEX(AView: TImageEnView;
      AFaceIdx: Integer;
      AFaceInfo: TFaceBaseInfo; AColor: TColor = clBlue; AWidth: Integer = 2;
      ADrawIndex: Boolean = true; AZoomRotation: Double = 1; ATextSize: Integer =
      12; AAlphaBlend: Boolean = false; ASourceConstantAlpha: Integer = 180;
      ABlendColor: TColor = -1);
    class procedure DrawFaceRectEX(AView: TImageEnView; AFaceIdx: Integer;
      AFaceRect: MRECT; AColor: TColor = clBlue; AWidth: Integer = 2; ADrawIndex:
      Boolean = true; AZoomRotation: Double = 1; ATextSize: Integer = 12;
      AAlphaBlend: Boolean = false; ASourceConstantAlpha: Integer = 180;
      ABlendColor: TColor = -1);
    function ExtractFaceFeatureFromIEBitmap(AIEBitmap: TIEBitmap; AFaceRegion:
      AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL; AOutIEBitmp:
      TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter:
      TResampleFilter; AUseCache: Boolean): Boolean;
    function MatchFaceWithIEBitmaps(AInBitmap1, AInBitmap2, AOutIEBitmp1,
      AOutIEBitmp2: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
      AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean):
      Single; overload;
    function MatchFaceWithIEBitmaps(AInBitmap1, AInBitmap2, AOutIEBitmp1,
      AOutIEBitmp2: TIEBitmap; AContrast: Double; AUseCache: Boolean): Single;
      overload;
    function TrackFacesFromIEBitmap(ABitmap: TIEBitmap; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; AUseCache: Boolean): Boolean;
    class function ReadFromFile(AFileName: string; var AImgData: TImgdataInfo;
      AOutIEBitmp: TIEBitmap; AResampleWidth: Integer = 0; AResampleHeight:
      Integer = 0; AResampleFilter: TResampleFilter = rfNone; AContrast: Double =
      0): Boolean;
    class function ReadIEBitmap(ABitmap: TIEBitmap;
      var AImgDataInfo: TImgdataInfo;
      AOutIEBitmp: TIEBitmap; AResampleWidth: Integer = 0; AResampleHeight:
      Integer = 0; AResampleFilter: TResampleFilter = rfNone; AContrast: Double =
      0): Boolean; overload;
    function TrackFacesAndAgeGenderFromIEBitmap(ABitmap: TIEBitmap;
      var AFaceInfos:
      TList<TFaceBaseInfo>; AUseCache: Boolean): Boolean;
    function DetectFacesAndAgeGenderFromIEBitmap(ABitmap: TIEBitmap; var
      AFaceInfos: TList<TFaceBaseInfo>; AOutIEBitmp: TIEBitmap; AResampleWidth,
      AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
      Double; AUseCache: Boolean): Boolean; overload;
    function DRAGfromIEBitmap(ABitmap: TIEBitmap; var AFaceInfos:
      TList<TFaceBaseInfo>; var AFaceModels: TFaceModels; AOutIEBitmp: TIEBitmap;
      AUseCache: Boolean): Boolean; overload;
    function DRAGfromFile(AFileName: string;
      var AFaceInfos: TList<TFaceBaseInfo>;
      var AFaceModels: TFaceModels; AOutIEBitmp: TIEBitmap; AUseCache: Boolean):
      Boolean; overload;
    function DRAGfromFile(AFileName: string;
      var AFaceInfos: TList<TFaceBaseInfo>;
      var AFaceModels: TFaceModels; AOutIEBitmp: TIEBitmap; AResampleWidth,
      AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
      Double; AUseCache: Boolean): Boolean; overload;
{$IFDEF ARC_RZ_SDK}
    function RzFicFaceDataFeatureExtractionFromIEBitmap(ABitmap: TIEBitmap;
      isVideo: Boolean; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight:
      Integer; AResampleFilter: TResampleFilter; AContrast: Double; AUseCache:
      Boolean): Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromIEBitmap(ABitmap: TIEBitmap;
      isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES; AOutIEBitmp: TIEBitmap;
      AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter;
      AContrast: Double; AUseCache: Boolean): Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromFile(AFile: String; isVideo:
      Boolean; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
      AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean):
      Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromFile(AFile: String; isVideo:
      Boolean; var AFaceRes: AFIC_FSDK_FACERES; AOutIEBitmp: TIEBitmap;
      AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter;
      AContrast: Double; AUseCache: Boolean): Boolean; overload;
    // 1 ��֤�ȶԣ����ڴ����룩
    function RzFicCompareFromIEBitmap(AZjz, ARyZP: TIEBitmap; isVideo: Boolean; var
      ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single =
      0.82): Boolean; overload;
    // 1 ��֤�ȶԣ����ڴ����룩
    function RzFicCompareFromIEBitmap(AZjz, ARyZP: TIEBitmap; isVideo: Boolean; var
      ASimilarScore: Single; var ACompareResult: Integer; var AFaceRes:
      AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean; overload;
    // 1 ��֤�ȶԣ����ļ����룩
    function RzFicCompareFromFile(AZjz, ARyZP: string; isVideo: Boolean; var
      ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single =
      0.82): Boolean; overload;
    // 1 ��֤�ȶԣ����ļ����룩
    function RzFicCompareFromFile(AZjz, ARyZP: string; isVideo: Boolean; var
      ASimilarScore: Single; var ACompareResult: Integer; var AFaceRes:
      AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean; overload;
    function RzFicIdCardDataFeatureExtractionFromIEBitmap(ABitmap, AOutIEBitmp:
      TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter:
      TResampleFilter; AContrast: Double): Boolean;
    function RzFicIdCardDataFeatureExtractionFromFile(AFile: String; AOutIEBitmp:
      TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter:
      TResampleFilter; AContrast: Double): Boolean;
{$ENDIF}
  published
    property ContrastRatio: Double read FContrastRatio write FContrastRatio;
    property ResampleFilter: TResampleFilter read FResampleFilter write
      FResampleFilter;
    property ResampleHeight: Integer read FResampleHeight write FResampleHeight;
    property ResampleWidth: Integer read FResampleWidth write FResampleWidth;
  end;

implementation

constructor TArcFaceSDKIEVersion.Create;
begin
  inherited;
  FResampleFilter := rfLanczos3;
  FResampleWidth := 0;
  FResampleHeight := 0;
  FContrastRatio := 0;
  FImgDataInfoCache.pImgData := nil;
end;

destructor TArcFaceSDKIEVersion.Destroy;
begin
  inherited;
  if FImgDataInfoCache.pImgData <> nil then
    FreeMem(FImgDataInfoCache.pImgData);
end;

//

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.CropFace
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ������������Ϣ�ü����������ļ�
  ����:
  ASouceIEBitmap, // ԴBMP
  ADestBitmap: TIEBitmap; // Ŀ��BMP
  AFaceRegion: AFR_FSDK_FACEINPUT; // ��������
  AExtendRatio, // ��չ���ʣ���СΪ0��ʵ��Ӧ���ٳ���100
  AResampleWidth, // Ŀ��ͼ����,0��ʾ�������߶ȱ䶯
  AResampleHeight: Integer; // Ŀ��ͼ��߶�,0��ʾ��������ȱ䶯
  AResampleFilter: TResampleFilter // �����˾�
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
class function TArcFaceSDKIEVersion.CropFace(
  ASouceIEBitmap,
  ADestBitmap: TIEBitmap;
  AFaceRegion: AFR_FSDK_FACEINPUT;
  AExtendRatio,
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter
  ): Boolean;
var
  iLeft, iTop, iRight, iBottom, iWidthExtend, iHeightExtend, iTmp: Integer;
  fHvsW: Double;
  iWidth, iHeight: Integer;
begin
  Result := false;
  if ASouceIEBitmap = nil then
    Exit;

  // ͼ��߿�ȣ�������Ÿ߿�������һΪ0��ʾά�ֱ��ʲ���
  if (AResampleWidth <= 0) or (AResampleHeight <= 0) then
    fHvsW := 0
  else
    fHvsW := AResampleHeight / AResampleWidth;

  // ͼ�����������������ɢ������
  iWidthExtend := Round((AFaceRegion.rcFace.right - AFaceRegion.rcFace.left) *
    (AExtendRatio / 100));
  iHeightExtend :=
    Round((AFaceRegion.rcFace.bottom - AFaceRegion.rcFace.top) *
    (AExtendRatio / 100));

  // ��������չ
  iLeft := AFaceRegion.rcFace.left - iWidthExtend;
  iRight := AFaceRegion.rcFace.right + iWidthExtend;
  iTop := AFaceRegion.rcFace.top - iHeightExtend;
  iBottom := AFaceRegion.rcFace.bottom + iHeightExtend;

  // ��ʱ���
  iWidth := Abs(iRight - iLeft);
  iHeight := Abs(iBottom - iTop);

  // ��� ��/�� > 1�����ȱ��ֲ��䣬�ٴ���չ�߶�
  if fHvsW > 1 then
  begin
    iTmp := (Max(Round(iWidth * fHvsW), iHeight) - iHeight) div 2;
    // ���¶�Ϊ������
    iTop := iTop - iTmp;
    iBottom := iBottom + iTmp;
  end
  // ��� 0 < ��/�� <= 1����߶ȱ��ֲ��䣬�ٴ���չ���
  else if fHvsW > 0 then
  begin
    iTmp := (Max(Round(iHeight / fHvsW), iWidth) - iWidth) div 2;
    iLeft := iLeft - iTmp;
    iRight := iRight + iTmp;
  end;

  // �����С��0���ҵ״���ԭʼͼ��߶�
  if (iTop < 0) and (iBottom > ASouceIEBitmap.Height) then
  begin
    // ����0
    iTop := 0;
    // ����ԭʼͼ��߶�
    iBottom := ASouceIEBitmap.Height;
  end
  // ����С��0
  else if iTop < 0 then
  begin
    // ��չ��
    iBottom := Min(iBottom - iTop, ASouceIEBitmap.Height);
    iTop := 0;
  end
  // ���״���ԭʼͼ��߶�
  else if iBottom > ASouceIEBitmap.Height then
  begin
    // ��չ��
    iTop := Max(iTop - (iBottom - ASouceIEBitmap.Height), 0);
    iBottom := ASouceIEBitmap.Height;
  end;

  // ������С��0�����ұߴ���ԭʼͼ����
  if (iLeft < 0) and (iRight > ASouceIEBitmap.Width) then
  begin
    iLeft := 0;
    iRight := ASouceIEBitmap.Width;
  end
  // �����С��0
  else if iLeft < 0 then
  begin
    iRight := Min(iRight - iLeft, ASouceIEBitmap.Width);
    iLeft := 0;
  end
  // ���ұߴ���ԭʼͼ����
  else if iRight > ASouceIEBitmap.Width then
  begin
    iLeft := Max(iLeft - (iRight - ASouceIEBitmap.Width), 0);
    iRight := ASouceIEBitmap.Width;
  end;

  if ADestBitmap = nil then
    ADestBitmap := TIEBitmap.Create;

  // ����Ŀ��ͼ����
  ADestBitmap.Width := Abs(iRight - iLeft);
  ADestBitmap.Height := Abs(iBottom - iTop);

  // ����ͼ��
  ASouceIEBitmap.CopyRectTo(ADestBitmap, iLeft, iTop, 0, 0, Abs(iRight - iLeft),
    Abs(iBottom - iTop));
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ�ú�������Ϣ�б�
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬���Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;

  if FFaceDetectionEngine = nil then
    Exit;

  if AFaceRegions = nil then
    AFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;

  // ʹ�û���
  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if not ReadIEBitmap(ABitmap, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;
  // �������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput,
    pFaceRes);
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('���������ʱ��' + IntToStr(T));
{$ENDIF}
  if nRet = MOK then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);

    if AFaceModels = nil then
      AFaceModels := TFaceModels.Create;
{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    Result := ExtractFaceFeatures(offInput, AFaceRegions, AFaceModels);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('��ȡ������ʱ��' + IntToStr(T));
{$ENDIF}
  end;

  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ�ú�������Ϣ�б����Ų���ʹ�ñ�����ʵ�������Ų�������
  ResampleWidth��ResampleHeight��ResampleFilter�Ȳ���ʹ����ʵ����Ӧ����
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬���Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AUseCache: Boolean
  ): Boolean;
begin
  Result := DetectAndRecognitionFacesFromIEBitmap(ABitmap, AFaceRegions,
    AFaceModels, AOutIEBitmp, FResampleWidth, FResampleHeight, FResampleFilter,
    FContrastRatio, AUseCache);
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromBitmapEX
  ����:      NJTZ
  ����:      2018.09.22
  ����:      �ӱ�׼Bitmap��ȡ����λ�ú�������Ϣ�б�
  ����:
  ABitmap: TBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromBitmapEX(
  ABitmap: TBitmap;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lIEBitmap: TIEBitmap;
begin
  lIEBitmap := TIEBitmap.Create;
  try
    lIEBitmap.Assign(ABitmap);
    Result := DetectAndRecognitionFacesFromIEBitmap(lIEBitmap, AFaceRegions,
      AFaceModels, AOutIEBitmp, AResampleWidth, AResampleHeight,
      AResampleFilter, AContrast, AUseCache);
  finally
    lIEBitmap.Free;
  end;
end;

//

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromBitmapEX
  ����:      NJTZ
  ����:      2018.09.22
  ����:      �ӱ�׼λͼ�л�ȡ����λ�á��Ա��������Ϣ�б�
  ����:
  ABitmap: TBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromBitmapEX(
  ABitmap: TBitmap;
  var AFaceInfos: TList<TFaceBaseInfo>;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lIEBitmap: TIEBitmap;
begin
  lIEBitmap := TIEBitmap.Create;
  try
    lIEBitmap.Assign(ABitmap);
    Result := DetectFacesAndAgeGenderFromIEBitmap(lIEBitmap, AFaceInfos,
      AOutIEBitmp, AResampleWidth, AResampleHeight, AResampleFilter, AContrast,
      AUseCache);
  finally
    lIEBitmap.Free;
  end;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromFileEx
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ͼ���ļ��м������λ����Ϣ�б���ȡ���м�⵽������������Ϣ,֧�ֳ�����ʽͼ���ļ�
  ����:
  AFileName: string; // �ļ���
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectAndRecognitionFacesFromFileEx(
  AFileName: string;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lIEBitmap: TIEBitmap;
  io: TImageEnIO;
begin
  Result := false;
  if not FileExists(AFileName) then
    Exit;

  lIEBitmap := TIEBitmap.Create;
  io := TImageEnIO.Create(nil);
  try
    io.AttachedIEBitmap := lIEBitmap;
    io.LoadFromFile(AFileName);
    Result := DetectAndRecognitionFacesFromIEBitmap(lIEBitmap, AFaceRegions,
      AFaceModels, AOutIEBitmp, AResampleWidth, AResampleHeight,
      AResampleFilter, AContrast, AUseCache);
  finally
    lIEBitmap.Free;
    io.Free;
  end;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DRAGfromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DRAGfromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceInfos: TList<TFaceBaseInfo>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  lFaceRes_Age: ASAE_FSDK_AGEFACEINPUT;
  lFaceRes_Gender: ASGE_FSDK_GENDERFACEINPUT;
  nRet: MRESULT;
  lFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  lAgeRes: ASAE_FSDK_AGERESULT;
  lGenderRes: ASGE_FSDK_GENDERRESULT;
  lAges: TArray<Integer>;
  lGenders: TArray<Integer>;
  lFaceInfo: TFaceBaseInfo;
  i, iFaces: Integer;
  ArrFaceOrient: array of AFD_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;
  if AFaceModels = nil then
    AFaceModels := TFaceModels.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  // ʹ�û���
  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if not ReadIEBitmap(ABitmap, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;
  // �������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput,
    pFaceRes);
{$IFDEF DEBUG}
  DoLog('���������ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
  if nRet = MOK then
  begin

    Result := true;

    lFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
    try

      ExtractFaceBoxs(pFaceRes^, lFaceRegions);

      if lFaceRegions.Count > 0 then
      begin

        iFaces := lFaceRegions.Count;
        SetLength(ArrFaceOrient, iFaces);
        SetLength(ArrFaceRect, iFaces);
        for i := 0 to iFaces - 1 do
        begin
          ArrFaceOrient[i] := lFaceRegions.Items[i].lOrient;
          ArrFaceRect[i] := lFaceRegions.Items[i].rcFace;
        end;
        // ===================================================
        // �������
        // ===================================================
        if (FFaceAgeEngine <> nil) then
        begin
          with lFaceRes_Age do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

{$IFDEF DEBUG}
          T := GetTickCount;
{$ENDIF}
          if ASAE_FSDK_AgeEstimation_StaticImage(
            FFaceAgeEngine, // [in] age estimation engine
            @offInput, // [in] the original image information
            // [in] the face rectangles information
            @lFaceRes_Age,
            // [out] the results of age estimation
            lAgeRes
            ) = MOK then
            // �ֽ���������
            ExtractFaceAges(lAgeRes, lAges)
          else
            Result := false;
{$IFDEF DEBUG}
          DoLog('��������ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
        end
        else
          Result := false;

        // ===================================================
        // ����Ա�
        // ===================================================
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

{$IFDEF DEBUG}
          T := GetTickCount;
{$ENDIF}
          if ASGE_FSDK_GenderEstimation_StaticImage(
            FFaceGenderEngine, // [in] Gender estimation engine
            @offInput, // [in] the original imGender information
            // [in] the face rectangles information
            @lFaceRes_Gender,
            // [out] the results of Gender estimation
            lGenderRes
            ) = MOK then
            // �ֽ������Ա�
            ExtractFaceGenders(lGenderRes, lGenders)
          else
            Result := false;
{$IFDEF DEBUG}
          DoLog('����Ա��ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
        end
        else
          Result := false;

        for i := 0 to iFaces - 1 do
        begin
          lFaceInfo.Init;
          lFaceInfo.FaceRect := ArrFaceRect[i];
          lFaceInfo.FaceOrient := ArrFaceOrient[i];
          if i < Length(lAges) then
            lFaceInfo.Age := lAges[i];
          if i < Length(lGenders) then
            lFaceInfo.Gender := lGenders[i];
          AFaceInfos.Add(lFaceInfo);
        end;


        // ===================================================
        // ��ȡ����
        // ===================================================

{$IFDEF DEBUG}
        T := GetTickCount;
{$ENDIF}
        if not ExtractFaceFeatures(offInput, lFaceRegions, AFaceModels) then
          Result := false;
{$IFDEF DEBUG}
        DoLog('��ȡ������ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
      end;

    finally
      lFaceRegions.Free;
    end;
  end;

  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      // ��TIEBitmap�л�ȡ����λ�á��Ա��������Ϣ�б�,���ֲ���ʹ����ʵ������
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceInfos: TList<TFaceBaseInfo>;
  AOutIEBitmp: TIEBitmap;
  AUseCache: Boolean
  ): Boolean;
begin
  Result := DetectFacesAndAgeGenderFromIEBitmap(ABitmap, AFaceInfos,
    AOutIEBitmp, FResampleWidth, FResampleHeight, FResampleFilter,
    FContrastRatio, AUseCache);
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromFileEx
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ͼ���ļ��л�ȡ����λ�á��Ա��������Ϣ�б�
  ����:
  AFileName: string; //ͼ���ļ���
  var AFaceInfos: TList<TFaceBaseInfo>; //����������Ϣ�б�
  AOutIEBitmp: TIEBitmap; //���ź������Ŀ��λͼ
  AResampleWidth, //���ſ��
  AResampleHeight: Integer; //���Ÿ߶�
  AResampleFilter: TResampleFilter; //�����˾�
  AContrast: Double; //�Աȶȣ�Ĭ��0������
  AUseCache: Boolean//�Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromFileEx(
  AFileName: string;
  var AFaceInfos: TList<TFaceBaseInfo>;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lIEBitmap: TIEBitmap;
  io: TImageEnIO;
begin
  Result := false;
  if not FileExists(AFileName) then
    Exit;

  lIEBitmap := TIEBitmap.Create;
  io := TImageEnIO.Create(nil);
  try
    io.AttachedIEBitmap := lIEBitmap;
    io.LoadFromFile(AFileName);
    Result := DetectFacesAndAgeGenderFromIEBitmap(lIEBitmap, AFaceInfos,
      AOutIEBitmp, AResampleWidth, AResampleHeight, AResampleFilter, AContrast,
      AUseCache);
  finally
    lIEBitmap.Free;
    io.Free;
  end;
end;

// ��IEBitmam�л�ȡ����λ����Ϣ�б�
function TArcFaceSDKIEVersion.DetectFacesFromIEBitmap(ABitmap: TIEBitmap; var
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; AOutIEBitmp: TIEBitmap;
  AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter;
  AContrast: Double; AUseCache: Boolean): Boolean;
var
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  lImgData: TImgdataInfo;
begin
  Result := false;

  if FFaceDetectionEngine = nil then
    Exit;

  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

  if not ReadIEBitmap(ABitmap, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;
  // �������
  if AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput, pFaceRes)
    = MOK then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectFacesFromFile
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ͼ���ļ��л�ȡ����λ����Ϣ�б�
  ����:
  AFile: string; // ͼ���ļ���
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectFacesFromFile(
  AFile: string;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceDetectionEngine = nil then
    Exit;

  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

  if not ReadFromFile(AFile, lImgData, AOutIEBitmp,
    AResampleWidth, AResampleHeight, AResampleFilter, AContrast) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;

  // �������
  if AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput, pFaceRes)
    = MOK then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;

end;

// ���ļ��л�ȡ����λ����Ϣ�б����ֲ���ʹ����ʵ������ֵ
function TArcFaceSDKIEVersion.DetectFacesFromFile(
  AFile: string; // ͼ���ļ�
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  AOutIEBitmp: TIEBitmap; // ���ź����Ŀ��λͼ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ�
  ): Boolean;
begin
  Result := DetectFacesFromFile(AFile, AFaceRegions, AOutIEBitmp,
    FResampleWidth, FResampleHeight, FResampleFilter, FContrastRatio,
    AUseCache);
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectFacesFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ����Ϣ�б����ֲ���ʹ����ʵ������ֵ
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectFacesFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  AOutIEBitmp: TIEBitmap;
  AUseCache: Boolean
  ): Boolean;
begin
  Result := DetectFacesFromIEBitmap(ABitmap, AFaceRegions, AOutIEBitmp,
    FResampleWidth, FResampleHeight, FResampleFilter, FContrastRatio,
    AUseCache);
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.TrackFacesFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ����Ϣ�б�׷��ģʽ�������ֲ���ʹ����ʵ������ֵ
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ��������Ϣ�б�
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.TrackFacesFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  AUseCache: Boolean
  ): Boolean;
var
  lImgDataInfo: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFT_FSDK_FACERES;
begin
  Result := false;

  if FFaceDetectionEngine = nil then
    Exit;

  if AUseCache then
    lImgDataInfo := FImgDataInfoCache
  else
    lImgDataInfo.pImgData := nil;

  if not ReadIEBitmap(ABitmap, lImgDataInfo, nil) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  // �������
  if AFT_FSDK_FaceFeatureDetect(FFaceTrackingEngine, @offInput, pFaceRes)
    = MOK then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if not AUseCache then
  begin
    if lImgDataInfo.pImgData <> nil then
      FreeMem(lImgDataInfo.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgDataInfo;
  end;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DrawFaceRectAgeGenderEX
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ImageEnView�ϻ��������Ա�����
  ����:
  AView: TImageEnView; // ͼ��Ԥ�����
  AFaceIdx: Integer; // ��������
  AFaceInfo: TFaceBaseInfo; // ����������Ϣ
  AColor: TColor = clBlue; // ������ɫ
  AWidth: Integer = 2; // ���߿��
  ADrawIndex: Boolean = true; // �Ƿ�����
  ATextSize: Integer = 0 // �ַ���С
  ����ֵ:    ��
  ------------------------------------------------------------------------------- }
class procedure TArcFaceSDKIEVersion.DrawFaceRectAgeGenderEX(AView:
  TImageEnView; AFaceIdx: Integer; AFaceInfo: TFaceBaseInfo; AColor: TColor =
  clBlue; AWidth: Integer = 2; ADrawIndex: Boolean = true; AZoomRotation:
  Double = 1; ATextSize: Integer = 12; AAlphaBlend: Boolean = false;
  ASourceConstantAlpha: Integer = 180; ABlendColor: TColor = -1);
begin
  DrawFaceRectAgeGender(AView.IEBitmap.Canvas, AFaceIdx, AFaceInfo, AColor,
    AWidth, ADrawIndex, AZoomRotation, ATextSize, AAlphaBlend,
    ASourceConstantAlpha, ABlendColor);
  AView.Update;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DrawFaceRectEX
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ImageEnView�ϻ�������
  ����:
  AView: TImageEnView; // ͼ��Ԥ�����
  AFaceIdx: Integer; // ��������
  AFaceRect: AFR_FSDK_FACEINPUT; // ��������Ϣ
  AColor: TColor = clBlue; // ������ɫ
  AWidth: Integer = 2; // ���߿��
  ADrawIndex: Boolean = true; // �Ƿ�����
  ATextSize: Integer = 0 // ���ִ�С
  ����ֵ:    ��
  ------------------------------------------------------------------------------- }
class procedure TArcFaceSDKIEVersion.DrawFaceRectEX(AView: TImageEnView;
  AFaceIdx: Integer; AFaceRect: MRECT; AColor: TColor = clBlue; AWidth:
  Integer = 2; ADrawIndex: Boolean = true; AZoomRotation: Double = 1;
  ATextSize: Integer = 12; AAlphaBlend: Boolean = false;
  ASourceConstantAlpha: Integer = 180; ABlendColor: TColor = -1);
begin
  DrawFaceRect(AView.IEBitmap.Canvas, AFaceIdx, AFaceRect, AColor, AWidth,
    ADrawIndex, AZoomRotation, ATextSize, AAlphaBlend, ASourceConstantAlpha,
    ABlendColor);
  AView.Update;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.ExtractFaceFeatureFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap����ȡ������������
  ����:
  AIEBitmap: TIEBitmap; // Դλͼ
  AFaceRegion: AFR_FSDK_FACEINPUT; // ��������Ϣ
  var AFaceModel: AFR_FSDK_FACEMODEL; // �������������������ڴ����ֶ�ʹ��freemem�ͷ�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.ExtractFaceFeatureFromIEBitmap(
  AIEBitmap: TIEBitmap; // Դλͼ
  AFaceRegion: AFR_FSDK_FACEINPUT; // ��������Ϣ
  var AFaceModel: AFR_FSDK_FACEMODEL; // �������������������ڴ����ֶ�ʹ��freemem�ͷ�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceRecognitionEngine = nil then
    Exit;

  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

  if not ReadIEBitmap(AIEBitmap, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;

  // ����������ȡ
  Result := ExtractFaceFeature(offInput, AFaceRegion, AFaceModel);

  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.MatchFaceWithIEBitmaps
  ����:      NJTZ
  ����:      2018.09.22
  ����:      �ȶ���������IEBitmap��ֻ�ȶԵ�һ��������
  ����:
  AInBitmap1, // ���Ƚ�Դͼһ
  AInBitmap2, // ���Ƚ�Դͼ��
  AOutIEBitmp1, // Դͼһ���ź������Ŀ��λͼ
  AOutIEBitmp2: TIEBitmap; // Դͼ�����ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Single
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.MatchFaceWithIEBitmaps(
  AInBitmap1, // ���Ƚ�Դͼһ
  AInBitmap2, // ���Ƚ�Դͼ��
  AOutIEBitmp1, // Դͼһ���ź������Ŀ��λͼ
  AOutIEBitmp2: TIEBitmap; // Դͼ�����ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ): Single;
var
  AFaceRegions1, AFaceRegions2: TList<AFR_FSDK_FACEINPUT>;
  AFaceModels1, AFaceModels2: TFaceModels;
  i: Integer;
  T: Cardinal;
begin
  Result := 0;

  if (AInBitmap1 = nil) or (AInBitmap2 = nil) then
    Exit;

  AFaceRegions1 := TList<AFR_FSDK_FACEINPUT>.Create;
  AFaceRegions2 := TList<AFR_FSDK_FACEINPUT>.Create;
  AFaceModels1 := TFaceModels.Create;
  AFaceModels2 := TFaceModels.Create;
  try
{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    DetectAndRecognitionFacesFromIEBitmap(AInBitmap1, AFaceRegions1,
      AFaceModels1, AOutIEBitmp1, AResampleWidth, AResampleHeight,
      AResampleFilter, AContrast, AUseCache);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('ȡͼһ������ʱ��' + IntToStr(T));
{$ENDIF}

{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    DetectAndRecognitionFacesFromIEBitmap(AInBitmap2, AFaceRegions2,
      AFaceModels2, AOutIEBitmp2, AResampleWidth, AResampleHeight,
      AResampleFilter, AContrast, AUseCache);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('ȡͼ��������ʱ��' + IntToStr(T));
{$ENDIF}
    if (AFaceModels1.Count > 0) and (AFaceModels2.Count > 0) then
    begin
{$IFDEF DEBUG}
      T := GetTickCount;
{$ENDIF}
      Result := MatchFace(AFaceModels1.FaceModel[0],
        AFaceModels2.FaceModel[0]);
{$IFDEF DEBUG}
      T := GetTickCount - T;
      DoLog('�ȶԺ�ʱ��' + IntToStr(T));
{$ENDIF}
    end;

  finally
    AFaceRegions1.Free;
    AFaceRegions2.Free;
    AFaceModels1.Free;
    AFaceModels2.Free;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.MatchFaceWithIEBitmaps
  ����:      NJTZ
  ����:      2018.09.22
  ����:      �ȶ���������IEBitmap��ֻ�ȶԵ�һ�������������ֲ���ʹ����ʵ��������ֵ
  ����:
  AInBitmap1, // ���Ƚ�Դͼһ
  AInBitmap2, // ���Ƚ�Դͼ��
  AOutIEBitmp1, // Դͼһ���ź������Ŀ��λͼ
  AOutIEBitmp2: TIEBitmap; // Դͼ�����ź������Ŀ��λͼ
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Single
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.MatchFaceWithIEBitmaps(
  AInBitmap1,
  AInBitmap2,
  AOutIEBitmp1,
  AOutIEBitmp2: TIEBitmap;
  AContrast: Double;
  AUseCache: Boolean
  ): Single;
begin
  Result := MatchFaceWithIEBitmaps(AInBitmap1, AInBitmap2, AOutIEBitmp1,
    AOutIEBitmp2, FResampleWidth, FResampleHeight, FResampleFilter, AContrast,
    AUseCache);
end;

// ���ļ��ж�ȡ��֧������ImageEN֧�ֵĸ�ʽ
class function TArcFaceSDKIEVersion.ReadFromFile(
  AFileName: string; // �ļ���
  var AImgData: TImgdataInfo; // ͼ�����ݽṹ
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth: Integer = 0; // ���ſ��
  AResampleHeight: Integer = 0; // ���Ÿ߶�
  AResampleFilter: TResampleFilter = rfNone; // �����˾�
  AContrast: Double = 0 // �����Աȶ�
  ): Boolean;
var
  lBitMap: TIEBitmap;
  io: TImageEnIO;
begin
  Result := false;
  if not FileExists(AFileName) then
    Exit;
  lBitMap := TIEBitmap.Create;
  io := TImageEnIO.Create(nil);
  try
    io.AttachedIEBitmap := lBitMap;
    io.LoadFromFile(AFileName);

    Result := ReadIEBitmap(lBitMap, AImgData, AOutIEBitmp,
      AResampleWidth, AResampleHeight, AResampleFilter, AContrast);

  finally
    io.Free;
    lBitMap.Free;
  end;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.ReadIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�ж�ȡ
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AImgDataInfo: TImgdataInfo; // ͼ�����ݽṹ
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth: Integer = 0; // ���ſ��
  AResampleHeight: Integer = 0; // ���Ÿ߶�
  AResampleFilter: TResampleFilter = rfNone; // �����˾�
  AContrast: Double = 0 // �����Աȶ�
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
class function TArcFaceSDKIEVersion.ReadIEBitmap(
  ABitmap: TIEBitmap; // Դλͼ
  var AImgDataInfo: TImgdataInfo; // ͼ�����ݽṹ
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth: Integer = 0; // ���ſ��
  AResampleHeight: Integer = 0; // ���Ÿ߶�
  AResampleFilter: TResampleFilter = rfNone; // �����˾�
  AContrast: Double = 0 // �����Աȶ�
  ): Boolean;
var
  iLineByte: Integer;
  iBitCount: Integer;
  i: Integer;
  lBitMap: TIEBitmap;
  proc: TImageEnProc;
  LastLP: Pointer;
  iNewWidth, iNewHeight: Integer;
begin
  Result := false;
  if ABitmap = nil then
    Exit;

  if (AResampleWidth <> 0) or (AResampleHeight <> 0) then
  begin
    lBitMap := TIEBitmap.Create;
    // ��������
    lBitMap.Assign(ABitmap);
    proc := TImageEnProc.Create(nil);
    try
      proc.AttachedIEBitmap := lBitMap;
      // ���ָ����Ⱥ͸߶Ⱦ�����0
      if (AResampleWidth > 0) and (AResampleHeight > 0) then
      begin
        // ������>�߱����Կ�Ϊ��׼���е����������Ը�Ϊ��׼���е������൱�ڿ�����
        if AResampleWidth / AResampleHeight > lBitMap.Width / lBitMap.Height
        then
        begin
          iNewWidth := AResampleWidth;
          iNewHeight := Round(AResampleWidth / lBitMap.Width * lBitMap.Height);
        end
        else
        begin
          iNewWidth := Round(AResampleHeight / lBitMap.Height * lBitMap.Width);
          iNewHeight := AResampleHeight;
        end;
        proc.Resample(iNewWidth, iNewHeight, AResampleFilter);
      end
      {
        else if (AResampleWidth < 0) and (AResampleHeight < 0) then
        begin
        if lBitMap.Width < Abs(AResampleWidth) then
        proc.Resample(Abs(AResampleWidth),
        Round(Abs(AResampleWidth) / lBitMap.Width *
        lBitMap.Height), AResampleFilter)
        else if lBitMap.Height < Abs(AResampleHeight) then
        proc.Resample(Round(Abs(AResampleHeight) / lBitMap.Height *
        lBitMap.Width), Abs(AResampleHeight), AResampleFilter)
        end
      }
      // ���ָ����С��0�����鵱ǰ���Ƿ�С��ָ����ľ���ֵ��
      // ���С�ڵ����Կ��Ϊ��׼���е���
      else if (AResampleWidth < 0) then
      begin
        if lBitMap.Width < Abs(AResampleWidth) then
          proc.Resample(Abs(AResampleWidth),
            Round(Abs(AResampleWidth) / lBitMap.Width *
            lBitMap.Height), AResampleFilter)
      end
      // ���ָ����С��0�����鵱ǰ���Ƿ�С��ָ���ߵľ���ֵ��
      // ���С�ڵ����Ը߶�Ϊ��׼���е���
      else if (AResampleHeight < 0) then
      begin
        if lBitMap.Height < Abs(AResampleHeight) then
          proc.Resample(Round(Abs(AResampleHeight) / lBitMap.Height *
            lBitMap.Width), Abs(AResampleHeight), AResampleFilter)
      end
      // ���ָ�������0�����Կ��Ϊ��׼���е���
      else if AResampleWidth > 0 then
        proc.Resample(AResampleWidth, Round(AResampleWidth / lBitMap.Width *
          lBitMap.Height), AResampleFilter)
        // ���ָ���ߴ���0�����Ը߶�Ϊ��׼���е���
      else if AResampleHeight > 0 then
        proc.Resample(Round(AResampleHeight / lBitMap.Height * lBitMap.Width),
          AResampleHeight, AResampleFilter);
      // �����Աȶ�
      if AContrast > 0 then
        proc.Contrast(AContrast);

    finally
      proc.Free;
    end;

  end
  else
    lBitMap := ABitmap;

  Result := false;
  iBitCount := lBitMap.BitCount;
  if iBitCount = 0 then
    Exit;

  iLineByte := Trunc((lBitMap.Width * iBitCount / 8 + 3) / 4) * 4;

  if
    (AImgDataInfo.BitCount <> iBitCount) or
    (AImgDataInfo.Width <> lBitMap.Width) or
    (AImgDataInfo.Height <> lBitMap.Height) then
  begin

    AImgDataInfo.BitCount := iBitCount;
    AImgDataInfo.Width := lBitMap.Width;
    AImgDataInfo.Height := lBitMap.Height;
    AImgDataInfo.LineBytes := iLineByte;

    if AImgDataInfo.pImgData <> nil then
      FreeMem(AImgDataInfo.pImgData);
    GetMem(AImgDataInfo.pImgData, iLineByte * lBitMap.Height);
  end
  else
  begin
    if AImgDataInfo.pImgData = nil then
      GetMem(AImgDataInfo.pImgData, iLineByte * lBitMap.Height);
  end;

  {
    LastLP := lBitMap.ScanLine[lBitMap.Height - 1];
    for i := 0 to lBitMap.Height - 1 do
    begin
    CopyMemory(Pointer(AImgDataInfo.pImgData + i * iLineByte),
    Pointer(Int64(LastLP) - i * iLineByte), iLineByte);
    end;
  }

  for i := lBitMap.Height - 1 downto 0 do
  begin
    CopyMemory(Pointer(AImgDataInfo.pImgData + i * iLineByte),
      lBitMap.ScanLine[i], iLineByte);
  end;

  if AOutIEBitmp <> nil then
    AOutIEBitmp.Assign(lBitMap);

  if lBitMap <> ABitmap then
    lBitMap.Free;

  Result := true;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.TrackFacesAndAgeGenderFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ�á��Ա��������Ϣ�б�׷��ģʽ��
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.TrackFacesAndAgeGenderFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceInfos: TList<TFaceBaseInfo>;
  AUseCache: Boolean
  ): Boolean;
var
  lImgDataInfo: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFT_FSDK_FACERES;
  lFaceRes_Age: ASAE_FSDK_AGEFACEINPUT;
  lFaceRes_Gender: ASGE_FSDK_GENDERFACEINPUT;
  lFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  lAgeRes: ASAE_FSDK_AGERESULT;
  lGenderRes: ASGE_FSDK_GENDERRESULT;
  lAges: TArray<Integer>;
  lGenders: TArray<Integer>;
  lFaceInfo: TFaceBaseInfo;
  i, iFaces: Integer;
  ArrFaceOrient: array of AFT_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
  R: MRESULT;
begin
  Result := false;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  if AUseCache then
    lImgDataInfo := FImgDataInfoCache
  else
    lImgDataInfo.pImgData := nil;

  if not ReadIEBitmap(ABitmap, lImgDataInfo, nil) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  lFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  try
    // �������
    R := AFT_FSDK_FaceFeatureDetect(FFaceTrackingEngine, @offInput, pFaceRes);
    if R = MOK then
    begin
      // �ֽ�����λ����Ϣ
      ExtractFaceBoxs(pFaceRes^, lFaceRegions);
      if lFaceRegions.Count > 0 then
      begin
        iFaces := lFaceRegions.Count;
        SetLength(ArrFaceOrient, iFaces);
        SetLength(ArrFaceRect, iFaces);
        for i := 0 to iFaces - 1 do
        begin
          ArrFaceOrient[i] := lFaceRegions.Items[i].lOrient;
          ArrFaceRect[i] := lFaceRegions.Items[i].rcFace;
        end;

        // �������
        if (FFaceAgeEngine <> nil) then
        begin
          with lFaceRes_Age do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASAE_FSDK_AgeEstimation_Preview(
            FFaceAgeEngine, // [in] age estimation engine
            @offInput, // [in] the original image information
            // [in] the face rectangles information
            @lFaceRes_Age,
            // [out] the results of age estimation
            lAgeRes
            ) = MOK then
            // �ֽ���������
            ExtractFaceAges(lAgeRes, lAges);

        end;

        // ����Ա�
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASGE_FSDK_GenderEstimation_Preview(
            FFaceGenderEngine, // [in] Gender estimation engine
            @offInput, // [in] the original imGender information
            // [in] the face rectangles information
            @lFaceRes_Gender,
            // [out] the results of Gender estimation
            lGenderRes
            ) = MOK then
            // �ֽ������Ա�
            ExtractFaceGenders(lGenderRes, lGenders);

        end;

        for i := 0 to iFaces - 1 do
        begin
          lFaceInfo.Init;
          lFaceInfo.FaceRect := ArrFaceRect[i];
          lFaceInfo.FaceOrient := ArrFaceOrient[i];
          if i < Length(lAges) then
            lFaceInfo.Age := lAges[i];
          if i < Length(lGenders) then
            lFaceInfo.Gender := lGenders[i];
          AFaceInfos.Add(lFaceInfo);
        end;
      end;

    end;
  finally
    FreeAndNil(lFaceRegions);
  end;

  if not AUseCache then
  begin
    if lImgDataInfo.pImgData <> nil then
      FreeMem(lImgDataInfo.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgDataInfo;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��IEBitmap�л�ȡ����λ�á��Ա��������Ϣ�б�
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DetectFacesAndAgeGenderFromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceInfos: TList<TFaceBaseInfo>;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;

var
  lImgDataInfo: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  lFaceRes_Age: ASAE_FSDK_AGEFACEINPUT;
  lFaceRes_Gender: ASGE_FSDK_GENDERFACEINPUT;
  lFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  lAgeRes: ASAE_FSDK_AGERESULT;
  lGenderRes: ASGE_FSDK_GENDERRESULT;
  lAges: TArray<Integer>;
  lGenders: TArray<Integer>;
  lFaceInfo: TFaceBaseInfo;
  i, iFaces: Integer;
  ArrFaceOrient: array of AFD_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
begin
  Result := false;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  if AUseCache then
    lImgDataInfo := FImgDataInfoCache
  else
    lImgDataInfo.pImgData := nil;

  if not ReadIEBitmap(ABitmap, lImgDataInfo, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  lFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  try
    // �������
    if AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput,
      pFaceRes) = MOK then
    begin
      // �ֽ�����λ����Ϣ
      ExtractFaceBoxs(pFaceRes^, lFaceRegions);
      if lFaceRegions.Count > 0 then
      begin
        iFaces := lFaceRegions.Count;
        SetLength(ArrFaceOrient, iFaces);
        SetLength(ArrFaceRect, iFaces);
        for i := 0 to iFaces - 1 do
        begin
          ArrFaceOrient[i] := lFaceRegions.Items[i].lOrient;
          ArrFaceRect[i] := lFaceRegions.Items[i].rcFace;
        end;

        // �������
        if (FFaceAgeEngine <> nil) then
        begin
          with lFaceRes_Age do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASAE_FSDK_AgeEstimation_StaticImage(
            FFaceAgeEngine, // [in]������������ʵ�����
            @offInput, // [in]ԭʼͼ������
            @lFaceRes_Age, // [in]��������Ϣ
            lAgeRes // [out]�����������
            ) = MOK then
            // �ֽ���������
            ExtractFaceAges(lAgeRes, lAges);

        end;

        // ����Ա�
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASGE_FSDK_GenderEstimation_StaticImage(
            FFaceGenderEngine, // [in]�Ա���������ʵ�����
            @offInput, // [in]ԭʼͼ������
            @lFaceRes_Gender, // [in]��������Ϣ
            lGenderRes // [out]�Ա��������
            ) = MOK then
            // �ֽ������Ա�
            ExtractFaceGenders(lGenderRes, lGenders);

        end;

        for i := 0 to iFaces - 1 do
        begin
          lFaceInfo.Init;
          lFaceInfo.FaceRect := ArrFaceRect[i];
          lFaceInfo.FaceOrient := ArrFaceOrient[i];
          if i < Length(lAges) then
            lFaceInfo.Age := lAges[i];
          if i < Length(lGenders) then
            lFaceInfo.Gender := lGenders[i];
          AFaceInfos.Add(lFaceInfo);
        end;
      end;

    end;
  finally
    FreeAndNil(lFaceRegions);
  end;

  if not AUseCache then
  begin
    if lImgDataInfo.pImgData <> nil then
      FreeMem(lImgDataInfo.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgDataInfo;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DRAGfromIEBitmap
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��TIEBitmap�л�ȡ����λ�á��Ա��������Ϣ�б�,���ֲ���ʹ����ʵ������ֵ
  ����:
  ABitmap: TIEBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DRAGfromIEBitmap(
  ABitmap: TIEBitmap;
  var AFaceInfos: TList<TFaceBaseInfo>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AUseCache: Boolean
  ): Boolean;
begin
  Result := DRAGfromIEBitmap(ABitmap, AFaceInfos, AFaceModels,
    AOutIEBitmp, FResampleWidth, FResampleHeight, FResampleFilter,
    FContrastRatio, AUseCache);
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DRAGfromFile
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ͼ���ļ��л�ȡ����λ�á��Ա��������Ϣ�б�,���ֲ���ʹ����ʵ������ֵ
  ����:
  AFileName: string; // ͼ���ļ�����֧�� ImageEN ֧�ֵ�����ͼ���ʽ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DRAGfromFile(
  AFileName: string;
  var AFaceInfos: TList<TFaceBaseInfo>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AUseCache: Boolean
  ): Boolean;
begin
  Result := DRAGfromFile(AFileName, AFaceInfos, AFaceModels,
    AOutIEBitmp, FResampleWidth, FResampleHeight, FResampleFilter,
    FContrastRatio, AUseCache);
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.DRAGfromFile
  ����:      NJTZ
  ����:      2018.09.22
  ����:      ��ͼ���ļ��л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
  ����:
  AFileName: string; // ͼ���ļ�����֧�� ImageEN ֧�ֵ�����ͼ���ʽ
  var AFaceInfos: TList<TFaceBaseInfo>; // ����������Ϣ�б�
  var AFaceModels: TFaceModels; // ����������
  AOutIEBitmp: TIEBitmap; // ���ź������Ŀ��λͼ
  AResampleWidth, // ���ſ��
  AResampleHeight: Integer; // ���Ÿ߶�
  AResampleFilter: TResampleFilter; // �����˾�
  AContrast: Double; // �Աȶȣ�Ĭ��0������
  AUseCache: Boolean // �Ƿ�ʹ�û���ռ䣬ʹ�ÿ��Ա���Ƶ�������ͷ��ڴ棬Ӧע���̰߳�ȫ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
function TArcFaceSDKIEVersion.DRAGfromFile(
  AFileName: string;
  var AFaceInfos: TList<TFaceBaseInfo>;
  var AFaceModels: TFaceModels;
  AOutIEBitmp: TIEBitmap;
  AResampleWidth,
  AResampleHeight: Integer;
  AResampleFilter: TResampleFilter;
  AContrast: Double;
  AUseCache: Boolean
  ): Boolean;
var
  lIEBitmap: TIEBitmap;
  io: TImageEnIO;
begin
  Result := false;
  if not FileExists(AFileName) then
    Exit;

  lIEBitmap := TIEBitmap.Create;
  io := TImageEnIO.Create(nil);
  try
    io.AttachedIEBitmap := lIEBitmap;
    io.LoadFromFile(AFileName);
    Result := DRAGfromIEBitmap(lIEBitmap, AFaceInfos,
      AFaceModels, AOutIEBitmp, AResampleWidth, AResampleHeight,
      AResampleFilter, AContrast, AUseCache);
  finally
    lIEBitmap.Free;
    io.Free;
  end;
end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��λͼ����ȡ��������������������λ�ã�ʹ����֤SDK����
  ����:      ABitmap: TIEBitmap; isVideo: Boolean; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromIEBitmap(
  ABitmap: TIEBitmap; isVideo: Boolean; AOutIEBitmp: TIEBitmap;
  AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter;
  AContrast: Double; AUseCache: Boolean): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicFaceDataFeatureExtractionFromIEBitmap(ABitmap, isVideo,
    lFaceRes, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast, AUseCache);
end;
{$ENDIF}

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��λͼ����ȡ������������������λ�ã���һ������ʹ����֤SDK����
  ����:      ABitmap: TIEBitmap; isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromIEBitmap(
  ABitmap: TIEBitmap; isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES;
  AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
  AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean):
  Boolean;
var
  lImgData: TImgdataInfo;
  RyZPInput: ASVLOFFSCREEN;
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;

  if FFaceRzFicEngine = nil then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

  if not ReadIEBitmap(ABitmap, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  RyZPInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(RyZPInput.pi32Pitch, SizeOf(RyZPInput.pi32Pitch), 0);
  FillChar(RyZPInput.ppu8Plane, SizeOf(RyZPInput.ppu8Plane), 0);

  RyZPInput.i32Width := lImgData.Width;
  RyZPInput.i32Height := lImgData.Height;

  RyZPInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  RyZPInput.pi32Pitch[0] := lImgData.LineBytes;

  // �������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := ArcSoft_FIC_FaceDataFeatureExtraction(
    FFaceRzFicEngine, // [in]  FIC ����Handle
    Bool2Int(isVideo), // [in]  ������������ 1-��Ƶ 0-��̬ͼƬ
    @RyZPInput, // [in]  ����ͼ��ԭʼ����
    // pFaceRes: LPAFIC_FSDK_FACERES
    AFaceRes // [out] �������� ������/������/�Ƕ�
    );
  Result := nRet = MOK;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('���������ʱ��' + IntToStr(T));
{$ENDIF}
  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;
end;
{$ENDIF}

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��ͼ���ļ�����ȡ��������������������λ�ã�ʹ����֤SDK����
  ����:      AFile: String; isVideo: Boolean; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromFile(AFile:
  String; isVideo: Boolean; AOutIEBitmp: TIEBitmap; AResampleWidth,
  AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast:
  Double; AUseCache: Boolean): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicFaceDataFeatureExtractionFromFile(AFile, isVideo, lFaceRes,
    AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast, AUseCache);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��ͼ���ļ�����ȡ������������������λ�ã�ʹ����֤SDK����
  ����:      AFile: String; isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast: Double; AUseCache: Boolean
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicFaceDataFeatureExtractionFromFile(AFile:
  String; isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES; AOutIEBitmp:
  TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter:
  TResampleFilter; AContrast: Double; AUseCache: Boolean): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;

  if FFaceRzFicEngine = nil then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if AUseCache then
    lImgData := FImgDataInfoCache
  else
    lImgData.pImgData := nil;

  if not ReadFromFile(AFile, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;

  // �������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := ArcSoft_FIC_FaceDataFeatureExtraction(
    FFaceRzFicEngine, // [in]  FIC ����Handle
    Bool2Int(isVideo), // [in]  ������������ 1-��Ƶ 0-��̬ͼƬ
    @offInput, // [in]  ����ͼ��ԭʼ����
    // pFaceRes: LPAFIC_FSDK_FACERES
    AFaceRes // [out] �������� ������/������/�Ƕ�
    );
  Result := nRet = MOK;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('���������ʱ��' + IntToStr(T));
{$ENDIF}
  if not AUseCache then
  begin
    if lImgData.pImgData <> nil then
      FreeMem(lImgData.pImgData)
  end
  else
  begin
    FImgDataInfoCache := lImgData;
  end;
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicCompareFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:      AZjz, ARyZP: TIEBitmap; isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicCompareFromIEBitmap(AZjz, ARyZP: TIEBitmap;
  isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer;
  AThreshold: Single = 0.82): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicCompareFromIEBitmap(AZjz, ARyZP, isVideo, ASimilarScore,
    ACompareResult,
    lFaceRes, AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicCompareFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:      AZjz, ARyZP: TIEBitmap; isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer; var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicCompareFromIEBitmap(AZjz, ARyZP: TIEBitmap;
  isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer;
  var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean;
begin
  Result := false;
  if RzFicIdCardDataFeatureExtractionFromIEBitmap(AZjz, nil, 0, 0,
    TResampleFilter.rfNone, 0) then
    if RzFicFaceDataFeatureExtractionFromIEBitmap(ARyZP, isVideo, AFaceRes,
      nil, 0, 0, TResampleFilter.rfNone, 0, false) then
      Result := RzFicFaceIdCardCompare(ASimilarScore, ACompareResult,
        AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicCompareFromFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:      AZjz, ARyZP: string; isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicCompareFromFile(AZjz, ARyZP: string;
  isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer;
  AThreshold: Single = 0.82): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicCompareFromFile(AZjz, ARyZP, isVideo, ASimilarScore,
    ACompareResult, lFaceRes, AThreshold);
end;
{$ENDIF}

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicCompareFromFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:      AZjz, ARyZP: string; isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer; var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicCompareFromFile(AZjz, ARyZP: string;
  isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer;
  var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean;
begin
  Result := false;
  if RzFicIdCardDataFeatureExtractionFromFile(AZjz, nil, 0, 0,
    TResampleFilter.rfNone, 0) then
    if RzFicFaceDataFeatureExtractionFromFile(ARyZP, isVideo, AFaceRes, nil,
      0, 0, TResampleFilter.rfNone, 0, false) then
      Result := RzFicFaceIdCardCompare(ASimilarScore, ACompareResult,
        AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicIdCardDataFeatureExtractionFromIEBitmap
  ����:      NJTZ
  ����:      2018.09.23
  ����:      �Ӷ���֤��Ƭλͼ����ȡ����������ʹ����֤SDK����
  ����:      ABitmap, AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast: Double
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicIdCardDataFeatureExtractionFromIEBitmap(
  ABitmap, AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
  AResampleFilter: TResampleFilter; AContrast: Double): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;
  if FFaceRzFicEngine = nil then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  lImgData.pImgData := nil;

  if not ReadIEBitmap(ABitmap, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;

  // ֤���ռ��
  nRet := ArcSoft_FIC_IdCardDataFeatureExtraction(
    FFaceRzFicEngine, // [in]  FIC ����Handle
    @offInput // [in]  ͼ��ԭʼ����
    );

  Result := nRet = MOK;

  if lImgData.pImgData <> nil then
    FreeMem(lImgData.pImgData);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDKIEVersion.RzFicIdCardDataFeatureExtractionFromFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      �Ӷ���֤��Ƭ�ļ�����ȡ����������ʹ����֤SDK����
  ����:      AFile: String; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer; AResampleFilter: TResampleFilter; AContrast: Double
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDKIEVersion.RzFicIdCardDataFeatureExtractionFromFile(AFile:
  String; AOutIEBitmp: TIEBitmap; AResampleWidth, AResampleHeight: Integer;
  AResampleFilter: TResampleFilter; AContrast: Double): Boolean;
var
  lImgData: TImgdataInfo;
  offInput: ASVLOFFSCREEN;
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;
  if FFaceRzFicEngine = nil then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  lImgData.pImgData := nil;

  if not ReadFromFile(AFile, lImgData, AOutIEBitmp, AResampleWidth,
    AResampleHeight, AResampleFilter, AContrast) then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgData.Width;
  offInput.i32Height := lImgData.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgData.pImgData);
  offInput.pi32Pitch[0] := lImgData.LineBytes;

  // ֤���ռ��
  nRet := ArcSoft_FIC_IdCardDataFeatureExtraction(
    FFaceRzFicEngine, // [in]  FIC ����Handle
    @offInput // [in]  ͼ��ԭʼ����
    );

  Result := nRet = MOK;

  if lImgData.pImgData <> nil then
    FreeMem(lImgData.pImgData);
end;
{$ENDIF}

end.
