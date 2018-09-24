(* ******************************************************
  * ��������ʶ��SDK��װ TBitmap ��
  * ��Ȩ���� (C) 2017 NJTZ  eMail:yhdgs@qq.com
  ****************************************************** *)

{$INCLUDE ARCFACE.INC}
unit ArcFaceSDK;

interface

uses Windows, Messages, SysUtils, System.Classes, math,
  amcomdef, ammemDef,
  arcsoft_fsdk_face_detection,
  arcsoft_fsdk_face_recognition,
  arcsoft_fsdk_face_tracking, asvloffscreendef, merrorDef,
  arcsoft_fsdk_age_estimation, arcsoft_fsdk_gender_estimation,
  Vcl.Graphics, Vcl.Imaging.jpeg, System.Generics.Collections,
{$IFDEF ARC_RZ_SDK}arcsoft_fsdk_fic {$ENDIF};

type

  TOnLogEvent = procedure(Const Msg: String) of object;

  // ͼ��������Ϣ�ṹ
  TImgDataInfo = record
    pImgData: PByte;
    Width: Integer;
    Height: Integer;
    LineBytes: Integer;
    BitCount: Integer;
  public
    procedure Init;
  end;

  // ����������Ϣ
  TFaceBaseInfo = record
    FaceRect: MRECT; // �������ο�
    FaceOrient: Integer; // ��������
    Age: Integer; // ����
    Gender: Integer; // �Ա�0�У�1Ů
  private
  public
    procedure Init;
  end;

  // ����������Ϣ
  TFaceFullInfo = record
    FaceRect: MRECT; // �������ο�
    FaceOrient: Integer; // ��������
    Age: Integer; // ����
    Gender: Integer; // �Ա�0�У�1Ů
    Model: AFR_FSDK_FACEMODEL; // ��������
  private
  public
    procedure Init;
  end;

  // ����������
  TFaceModels = class(TObject)
  protected
    FChanged: Boolean;
  private
    FModels: TList<AFR_FSDK_FACEMODEL>;
    function GetCount: Integer;
    function GetFaceModel(Index: Integer): AFR_FSDK_FACEMODEL;
    function GetItems(Index: Integer): AFR_FSDK_FACEMODEL;
  public
    constructor Create;
    destructor Destroy; override;
    function AddModel(AModel: AFR_FSDK_FACEMODEL): Integer;
    procedure Assign(ASource: TFaceModels); virtual;
    procedure AddModels(ASource: TFaceModels);
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    procedure ResetState;
    property Changed: Boolean read FChanged;
    property Count: Integer read GetCount;
    property FaceModel[Index: Integer]: AFR_FSDK_FACEMODEL read GetFaceModel;
    property Items[Index: Integer]: AFR_FSDK_FACEMODEL read GetItems;
  end;

  // �Զ���TJpegImage
  TuJpegImage = class(TJPEGImage)
  public
    function BitmapData: TBitmap;
  end;

  TEdzFaceModels = class(TFaceModels)
  private
    FBitmap: TBitmap;
    FRyID: String;
    FParams: String;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetParams(const Value: String);
    procedure SetRyID(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ASource: TFaceModels); override;
    procedure Clear; override;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property RyID: String read FRyID write SetRyID;
    property Params: String read FParams write SetParams;
  end;

  // ArcFaceSDK��װ����
  TArcFaceSDK = class(TObject)
  private
    FAppID: String;
    FAPPID_FIC: String;
    FEstimationBufferSize: Int64;
    FFaceAgeKey: String;
    FFaceRecognitionKey: string;
    FFaceTrackingKey: string;
    FFaceDetectionKey: string;
    FFaceGenderKey: String;
    FFaceRZKey_FIC: string;
    FMaxFace: Integer;
    FScale: Integer;
    FWorkKBufferSize: Int64;
    FOnLog: TOnLogEvent;
    FOrientPriority: TAFD_FSDK_OrientPriority;
    FpFaceRecognitionBuf: PByte;
    FpFaceTrackingBuf: PByte;
    FpFaceDetectionBuf: PByte;
    FpFaceAgeBuf: PByte;
    FpFaceGenderBuf: PByte;
    class procedure DrawAlpha(ACanvas: TCanvas; AWidth, AHeight, x1, y1, x2, y2,
      x3, y3: Integer; ASourceConstantAlpha: Integer = 180; AColor: TColor = 0);
      overload;
    procedure SetMaxFace(const Value: Integer);
    procedure SetScale(const Value: Integer);
  protected
    FFaceRecognitionEngine: MHandle;
    FFaceTrackingEngine: MHandle;
    FFaceDetectionEngine: MHandle;
    FFaceAgeEngine: MHandle;
    FFaceRzFicEngine: MHandle;
    FFaceGenderEngine: MHandle;
    function Bool2Int(B: Boolean): Integer;
    procedure DoLog(const Msg: String);
  public
    constructor Create;
    destructor Destroy; override;
    function DetectAndRecognitionFacesFromBmp(ABitmap: TBitmap;
      var AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
      var AFaceModels: TFaceModels): Boolean;
    function DetectFacesAndAgeGenderFromBitmap(ABitmap: TBitmap;
      var AFaceInfos: TList<TFaceBaseInfo>): Boolean;
    function DetectFacesFromBmp(ABitmap: TBitmap;
      var AFaceRegions: TList<AFR_FSDK_FACEINPUT>): Boolean;
    function TrackFacesFromBmp(ABitmap: TBitmap;
      var AFaceRegions: TList<AFR_FSDK_FACEINPUT>): Boolean;
    function DetectFacesFromBmpFile(AFile: string;
      var AFaceRegions: TList<AFR_FSDK_FACEINPUT>): Boolean;
    function DRAGfromJPGFile(AFileName: string;
      var AFaceInfos: TList<TFaceBaseInfo>; var AFaceModels: TFaceModels)
      : Boolean; overload;
    function DRAGfromBmp(ABitmap: TBitmap; var AFaceInfos: TList<TFaceBaseInfo>;
      var AFaceModels: TFaceModels): Boolean; overload;
    function DRAGfromBmpFile(AFileName: string;
      var AFaceInfos: TList<TFaceBaseInfo>; var AFaceModels: TFaceModels)
      : Boolean; overload;
    // 1 ͼ�����ų���
    class procedure DrawFaceRectAgeGender(ACanvas: TCanvas; AFaceIdx: Integer;
      AFaceInfo: TFaceBaseInfo; AColor: TColor = clBlue; APenWidth: Integer = 2;
      ADrawIndex: Boolean = true; AZoomRotation: Double = 1; ATextSize: Integer =
      0; AAlphaBlend: Boolean = false; ASourceConstantAlpha: Integer = 180;
      ABlendColor: TColor = -1);
    class procedure DrawFaceRect(ACanvas: TCanvas; AFaceIdx: Integer; AFaceRect:
      MRECT; AColor: TColor = clBlue; APenWidth: Integer = 2; ADrawIndex: Boolean
      = true; AZoomRotation: Double = 1; ATextSize: Integer = 12; AAlphaBlend:
      Boolean = false; ASourceConstantAlpha: Integer = 180; ABlendColor: TColor =
      -1);
    function TrackFacesFromBmpFile(AFile: string;
      var AFaceRegions: TList<AFR_FSDK_FACEINPUT>): Boolean;
    class procedure ExtractFaceBoxs(AFaces: AFD_FSDK_FACERES;
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>); overload;
    class procedure ExtractFaceBoxs(AFaces: AFT_FSDK_FACERES;
      var AFaceRegions: TList<AFR_FSDK_FACEINPUT>); overload;
    class procedure ExtractFaceAges(AFaceAgeResults: ASAE_FSDK_AGERESULT;
      var AFaceAges: TArray<Integer>); overload;
    class procedure ExtractFaceGenders(AFaceGenderResults
      : ASGE_FSDK_GENDERRESULT; var AFaceGenders: TArray<Integer>); overload;
    function ExtractFaceFeature(AFaceInput: ASVLOFFSCREEN;
      AFaceRegion: AFR_FSDK_FACEINPUT;
      var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
    function ExtractFaceFeatures(AFaceInput: ASVLOFFSCREEN;
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
      var AFaceModels: TFaceModels): Boolean;
    function ExtractFaceFeatureFromBmp(ABitmap: TBitmap;
      AFaceRegion: AFR_FSDK_FACEINPUT;
      var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
    function ExtractFaceFeaturesFromBmp(ABitmap: TBitmap;
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
      var AFaceModels: TFaceModels): Boolean;
    function ExtractFaceFeatureFromBmpFile(AFile: string;
      AFaceRegion: AFR_FSDK_FACEINPUT;
      var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
    function ExtractFaceFeaturesFromBmpFile(AFile: string;
      AFaceRegions: TList<AFR_FSDK_FACEINPUT>;
      var AFaceModels: TFaceModels): Boolean;
    function InitialFaceDetectionEngine(Deinitial: Boolean): Integer;
    function InitialFaceTrackingEngine(Deinitial: Boolean): Integer;
    function InitialFaceRecognitionEngine(Deinitial: Boolean): Integer;
    function InitialFaceAgeEngine(Deinitial: Boolean): Integer;
    function InitialFaceRzFicEngine(Deinitial: Boolean): Integer;
    function InitialFaceGenderEngine(Deinitial: Boolean): Integer;
    function MatchFace(AFaceModel1, AFaceModel2: AFR_FSDK_FACEMODEL): Single;
    function MatchFaceWithBitmaps(ABitmap1, ABitmap2: TBitmap): Single;
    function UnInitialFaceDetectionEngine: Integer;
    function UnInitialFaceTrackingEngine: Integer;
    function UnInitialFaceRecognitionEngine: Integer;
    class function ReadBmp(ABitmap: TBitmap;
      var AImgDataInfo: TImgDataInfo): Boolean;
    class function ReadBmpFile(AFileName: string;
      var AImgDataInfo: TImgDataInfo): Boolean; overload;
    class function ReadBmpFile(AFileName: string; ABitmap: TBitmap)
      : Boolean; overload;
    class function ReadJpegFile(AFileName: string;
      var AImgDataInfo: TImgDataInfo): Boolean; overload;
    class function ReadBmpStream(AStream: TMemoryStream;
      var AImgDataInfo: TImgDataInfo): Boolean;
    class function ReadJpegFile(AFileName: string; ABitmap: TBitmap)
      : Boolean; overload;
{$IFDEF ARC_RZ_SDK}
    function RzFicCompareFromBmp(AZjz, ARyZP: TBitmap; isVideo: Boolean;
      var ASimilarScore: Single; var ACompareResult: Integer;
      var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82)
      : Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromBmp(ABitmap: TBitmap; isVideo:
      Boolean; var AFaceRes: AFIC_FSDK_FACERES): Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromBmp(ARyZP: TBitmap;
      isVideo: Boolean): Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromBmpFile(AFile: String; isVideo:
      Boolean; var AFaceRes: AFIC_FSDK_FACERES): Boolean; overload;
    function RzFicFaceDataFeatureExtractionFromBmpFile(AFile: String; isVideo:
      Boolean): Boolean; overload;
    function RzFicIdCardDataFeatureExtractionFromBmp(ABitmap: TBitmap): Boolean;
    function RzFicFaceIdCardCompare(var ASimilarScore: Single;
      var ACompareResult: Integer; AThreshold: Single = 0.82): Boolean;
    function RzFicCompareFromBmp(AZjz, ARyZP: TBitmap; isVideo: Boolean; var
      ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single =
      0.82): Boolean; overload;
    function RzFicCompareFromBmpFile(AZjzFile, ARyZPFile: string;
      isVideo: Boolean; var
      ASimilarScore: Single; var ACompareResult: Integer; var AFaceRes:
      AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean; overload;
    function RzFicCompareFromBmpFile(AZjzFile, ARyZPFile: string;
      isVideo: Boolean;
      var ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single
      = 0.82): Boolean; overload;
    function RzFicIdCardDataFeatureExtractionFromBmpFile(AFile: string)
      : Boolean;
{$ENDIF}
    function TrackFacesAndAgeGenderFromBmp(ABitmap: TBitmap;
      var AFaceInfos: TList<TFaceBaseInfo>): Boolean;
    function UnInitialFaceAgeEngine: Integer;
    // 1 �ͷ���֤�ȶ�����
    function UnInitialFaceRzFicEngine: Integer;
    function UnInitialFaceGenderEngine: Integer;
    property AppID: String read FAppID write FAppID;
    property FaceDetectionKey: string read FFaceDetectionKey
      write FFaceDetectionKey;
    property FaceRecognitionKey: string read FFaceRecognitionKey
      write FFaceRecognitionKey;
    property FaceTrackingKey: string read FFaceTrackingKey
      write FFaceTrackingKey;
    property MaxFace: Integer read FMaxFace write SetMaxFace;
    property OnLog: TOnLogEvent read FOnLog write FOnLog;
    property APPID_FIC: String read FAPPID_FIC write FAPPID_FIC;
    property EstimationBufferSize: Int64 read FEstimationBufferSize
      write FEstimationBufferSize;
    property FaceAgeKey: String read FFaceAgeKey write FFaceAgeKey;
    property FaceGenderKey: String read FFaceGenderKey write FFaceGenderKey;
    property FaceRZKey_FIC: string read FFaceRZKey_FIC write FFaceRZKey_FIC;
    property OrientPriority: TAFD_FSDK_OrientPriority read FOrientPriority
      write FOrientPriority;
    property Scale: Integer read FScale write SetScale;
    property WorkKBufferSize: Int64 read FWorkKBufferSize
      write FWorkKBufferSize;
  end;

implementation

{$INCLUDE ArcFaceRZDllKeys.inc}


constructor TArcFaceSDK.Create;
begin
  inherited;
  // ����SDK��Ȩ��Ϣ
{$INCLUDE ArcFaceKeys.inc}
  FWorkKBufferSize := 40 * 1024 * 1024;
  FEstimationBufferSize := 30 * 1024 * 1024;
  FScale := 16;
  FMaxFace := 10;
  FOrientPriority := TAFD_FSDK_OrientPriority.AFD_FSDK_OPF_0_HIGHER_EXT;

  FFaceDetectionEngine := nil;
  FFaceRecognitionEngine := nil;
  FFaceTrackingEngine := nil;
  FFaceAgeEngine := nil;
  FFaceGenderEngine := nil;

  FpFaceDetectionBuf := nil;
  FpFaceRecognitionBuf := nil;
  FpFaceTrackingBuf := nil;
  FpFaceAgeBuf := nil;
  FpFaceGenderBuf := nil;

end;

destructor TArcFaceSDK.Destroy;
begin
  UnInitialFaceDetectionEngine;
  UnInitialFaceTrackingEngine;
  UnInitialFaceRecognitionEngine;
  UnInitialFaceAgeEngine;
  UnInitialFaceGenderEngine;
  UnInitialFaceRzFicEngine;
  inherited;
end;

function TArcFaceSDK.Bool2Int(B: Boolean): Integer;
begin
  if B then
    Result := 1
  else
    Result := 0;
end;

// �������λ�ò���ȡ������֧�ֶ�������
function TArcFaceSDK.DetectAndRecognitionFacesFromBmp(ABitmap: TBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // �������λ����Ϣ�б�
  var AFaceModels: TFaceModels // �������������Ϣ
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
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

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;
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

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��Bitmap�л�ȡ����λ�á��Ա��������Ϣ�б�
function TArcFaceSDK.DetectFacesAndAgeGenderFromBitmap(ABitmap: TBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo> // ���������Ϣ
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
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

  // ��Դλͼ�ж�ȡ����
  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;

  // ��ʼ������������Ϣ
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

          if ASAE_FSDK_AgeEstimation_StaticImage(FFaceAgeEngine,
            // [in]������������ʵ�����
            @offInput, // [in]ͼ������
            @lFaceRes_Age, // [in]��������Ϣ
            lAgeRes // [out]�����������
            ) = MOK then
            // �ֽ���������
            ExtractFaceAges(lAgeRes, lAges);
        end;

        // �Ա�����
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASGE_FSDK_GenderEstimation_StaticImage(FFaceGenderEngine,
            // [in]�Ա���������ʵ�����
            @offInput, // [in]ͼ������
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

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData)

end;

// ��λͼ�л�ȡ����λ����Ϣ�б�
function TArcFaceSDK.DetectFacesFromBmp(ABitmap: TBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT> // �������λ���б�
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceDetectionEngine = nil then
    Exit;

  // ��ȡλͼ���ڴ���
  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;
  // ����API�������
  if AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput, pFaceRes)
    = MOK then
  begin
    // ��ȡ����λ�ÿ���Ϣ���б�
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��ȡ����λ����Ϣ�б�����ģʽ
function TArcFaceSDK.TrackFacesFromBmp(ABitmap: TBitmap; // Դλͼ
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT> // �������λ����Ϣ�б�
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFT_FSDK_FACERES;
begin
  Result := false;

  if FFaceTrackingEngine = nil then
    Exit;

  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;
  // offInput.pi32Pitch[1] := offInput.i32Width div 2;
  // offInput.pi32Pitch[2] := offInput.i32Width div 2;
  // �������
  if AFT_FSDK_FaceFeatureDetect(FFaceTrackingEngine, @offInput, pFaceRes) = MOK
  then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ���ļ�Bmp�ļ��л�ȡ����λ����Ϣ�б���ȷ���ļ�Ϊ��ȷ��BMP��ʽ
function TArcFaceSDK.DetectFacesFromBmpFile(AFile: string; // Դ�ļ�
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT> // �������λ����Ϣ�б�
  ): Boolean;
var
  BMP: TBitmap;
begin
  Result := false;
  if FFaceDetectionEngine = nil then
    Exit;

  if not FileExists(AFile) then
    Exit;
  BMP := TBitmap.Create;
  try
    BMP.LoadFromFile(AFile);
    Result := DetectFacesFromBmp(BMP, AFaceRegions);
  finally
    BMP.Free;
  end;
end;

// ���ļ��л�ȡ����λ����Ϣ�б�׷��ģʽ��
function TArcFaceSDK.TrackFacesFromBmpFile(AFile: string; // Դ�ļ�
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT> // �������λ����Ϣ
  ): Boolean;
var
  BMP: TBitmap;
begin
  Result := false;
  if FFaceTrackingEngine = nil then
    Exit;

  if not FileExists(AFile) then
    Exit;
  BMP := TBitmap.Create;
  try
    // �����ļ�
    BMP.LoadFromFile(AFile);
    // �������
    Result := TrackFacesFromBmp(BMP, AFaceRegions);
  finally
    BMP.Free;
  end;
end;

procedure TArcFaceSDK.DoLog(const Msg: String);
begin
  if Assigned(FOnLog) then
    FOnLog(Msg);
end;

// ��JPG�ļ��л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
function TArcFaceSDK.DRAGfromJPGFile(AFileName: string; // JPEG�ļ���
  var AFaceInfos: TList<TFaceBaseInfo>; // �������������Ϣ�б�
  var AFaceModels: TFaceModels // ����������
  ): Boolean;
var
  lBitmap: TBitmap;
begin
  Result := false;
  if not FileExists(AFileName) then
    Exit;

  lBitmap := TBitmap.Create;
  try
    if ReadJpegFile(AFileName, lBitmap) then
      Result := DRAGfromBmp(lBitmap, AFaceInfos, AFaceModels);
  finally
    lBitmap.Free;
  end;
end;

// Bitmap�л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
function TArcFaceSDK.DRAGfromBmp(ABitmap: TBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo>; // �������������Ϣ�б�
  var AFaceModels: TFaceModels // ����������
  ): Boolean;
var
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
  lImgDataInfo: TImgDataInfo;
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

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;
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
          if ASAE_FSDK_AgeEstimation_StaticImage(FFaceAgeEngine,
            // [in]������������ʵ�����
            @offInput, // [in]ͼ��������Ϣ
            @lFaceRes_Age, // [in]��������Ϣ
            lAgeRes // [out]�Ա��������
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
        // �Ա�����
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
          if ASGE_FSDK_GenderEstimation_StaticImage(FFaceGenderEngine,
            // [in]�Ա���������ʵ�����
            @offInput, // [in]ͼ������
            @lFaceRes_Gender, // [in]��������Ϣ
            lGenderRes // [out]�Ա��������
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

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��BMP�ļ��л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
function TArcFaceSDK.DRAGfromBmpFile(AFileName: string; // �ļ���
  var AFaceInfos: TList<TFaceBaseInfo>; // �������������Ϣ�б�
  var AFaceModels: TFaceModels // ����������
  ): Boolean;
var
  lBitmap: TBitmap;
begin
  Result := false;
  if not FileExists(AFileName) then
    Exit;

  lBitmap := TBitmap.Create;
  try
    if ReadBmpFile(AFileName, lBitmap) then
      Result := DRAGfromBmp(lBitmap, AFaceInfos, AFaceModels);
  finally
    lBitmap.Free;
  end;
end;

// ��Canvas�ϻ����������䡢�Ա�
class procedure TArcFaceSDK.DrawFaceRectAgeGender(ACanvas: TCanvas; AFaceIdx:
  Integer; AFaceInfo: TFaceBaseInfo; AColor: TColor = clBlue; APenWidth:
  Integer = 2; ADrawIndex: Boolean = true; AZoomRotation: Double = 1;
  ATextSize: Integer = 0; AAlphaBlend: Boolean = false; ASourceConstantAlpha:
  Integer = 180; ABlendColor: TColor = -1);
var
  sText: string;
  iTextHeight, iTextWidth: Integer;
begin
  if ATextSize = 0 then
    ATextSize := 12;
  ACanvas.Pen.Color := AColor;
  ACanvas.Pen.Width := max(1, Round(APenWidth / AZoomRotation));
  ACanvas.Brush.Style := bsClear;
  // if ATextSize = 0 then
  // ACanvas.Font.Size :=
  // Round((AFaceInfo.FaceRect.bottom - AFaceInfo.FaceRect.top) / (10 * 1.5))
  // else
  ACanvas.Font.Name := '΢���ź�';
  ACanvas.Font.Size := Round(ATextSize / AZoomRotation);
  ACanvas.Font.Color := AColor;

  ACanvas.RoundRect(AFaceInfo.FaceRect.left, AFaceInfo.FaceRect.top,
    AFaceInfo.FaceRect.right, AFaceInfo.FaceRect.bottom, 0, 0);

  sText := '';
  case AFaceInfo.Gender of
    0:
      sText := '�Ա�:��';
    1:
      sText := '�Ա�:Ů';
  else
    sText := '�Ա�:δ֪';
  end;

  sText := sText + ' ����:' + IntToStr(AFaceInfo.Age);

  if ADrawIndex then
  begin
    if AFaceIdx <> -1 then
      sText := IntToStr(AFaceIdx) + ' ' + sText;
  end;

  if sText <> '' then
  begin
    iTextWidth := ACanvas.TextWidth(sText);
    iTextHeight := ACanvas.TextHeight(sText);

    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := AColor;
    if ACanvas.Brush.Color = clWhite then
      ACanvas.Font.Color := clBlack
    else
      ACanvas.Font.Color := clWhite;
    ACanvas.Font.Quality := fqClearType;

    ACanvas.RoundRect(AFaceInfo.FaceRect.left, AFaceInfo.FaceRect.top -
      iTextHeight - 6, max(AFaceInfo.FaceRect.right, AFaceInfo.FaceRect.left +
      iTextWidth + 10), AFaceInfo.FaceRect.top, 0, 0);

    ACanvas.TextOut(AFaceInfo.FaceRect.left + 5, AFaceInfo.FaceRect.top - 3 -
      iTextHeight, sText);
  end;

  // ����͸��
  if AAlphaBlend then
  begin
    DrawAlpha(ACanvas, AFaceInfo.FaceRect.right, AFaceInfo.FaceRect.bottom,
      AFaceInfo.FaceRect.left + ACanvas.Pen.Width,
      AFaceInfo.FaceRect.top + ACanvas.Pen.Width, AFaceInfo.FaceRect.right -
      ACanvas.Pen.Width, AFaceInfo.FaceRect.bottom - ACanvas.Pen.Width,
      0, 0, ASourceConstantAlpha, ABlendColor);
  end;

  ACanvas.Refresh;

end;

class procedure TArcFaceSDK.DrawAlpha(ACanvas: TCanvas; AWidth, AHeight, x1,
  y1, x2, y2, x3, y3: Integer; ASourceConstantAlpha: Integer = 180; AColor:
  TColor = 0);
var
  bf: BLENDFUNCTION;
  desBmp: TBitmap;
  rgn: HRGN;
begin
  with bf do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    AlphaFormat := 0;
    SourceConstantAlpha := ASourceConstantAlpha; // ͸���ȣ�0~255
  end;

  desBmp := TBitmap.Create;
  try

    desBmp.Width := AWidth;
    desBmp.Height := AHeight;

    if AColor >= 0 then
    begin
      desBmp.Canvas.Brush.Style := bsSolid;
      desBmp.Canvas.Brush.Color := AColor;
      desBmp.Canvas.Font.Quality := fqClearType;
      desBmp.Canvas.Rectangle(0, 0, AWidth, AHeight);
    end;

    Windows.AlphaBlend(desBmp.Canvas.Handle, 0, 0,
      desBmp.Width, desBmp.Height, ACanvas.Handle,
      0, 0, AWidth, AHeight, bf);

    rgn := CreateRoundRectRgn(x1, y1, x2, y2, x3, y3); // ����һ��Բ������
    SelectClipRgn(ACanvas.Handle, rgn);
    ACanvas.Draw(0, 0, desBmp);
  finally
    desBmp.Free;
  end
end;

// ��Canvas�ϻ�������
class procedure TArcFaceSDK.DrawFaceRect(ACanvas: TCanvas; AFaceIdx: Integer;
  AFaceRect: MRECT; AColor: TColor = clBlue; APenWidth: Integer = 2;
  ADrawIndex: Boolean = true; AZoomRotation: Double = 1; ATextSize: Integer =
  12; AAlphaBlend: Boolean = false; ASourceConstantAlpha: Integer = 180;
  ABlendColor: TColor = -1);
var
  sText: string;
  iTextHeight, iTextWidth: Integer;
begin
  ATextSize := 0;
  ACanvas.Pen.Color := AColor;
  ACanvas.Pen.Width := max(1, Round(APenWidth / AZoomRotation));
  ACanvas.Brush.Style := bsClear;
  // if ATextSize = 0 then
  // ACanvas.Font.Size :=
  // Round((AFaceRect.FaceRect.bottom - AFaceRect.FaceRect.top) / (10 * 1.5))
  // else
  ACanvas.Font.Name := '΢���ź�';
  ACanvas.Font.Size := Round(ATextSize / AZoomRotation);
  ACanvas.Font.Color := AColor;

  ACanvas.RoundRect(AFaceRect.left, AFaceRect.top,
    AFaceRect.right, AFaceRect.bottom, 0, 0);

  sText := '';
  if ADrawIndex then
  begin
    if AFaceIdx <> -1 then
      sText := IntToStr(AFaceIdx);
  end;

  if sText <> '' then
  begin
    iTextWidth := ACanvas.TextWidth(sText);
    iTextHeight := ACanvas.TextHeight(sText);

    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := AColor;
    if ACanvas.Brush.Color = clWhite then
      ACanvas.Font.Color := clBlack
    else
      ACanvas.Font.Color := clWhite;
    ACanvas.Font.Quality := fqClearType;

    ACanvas.RoundRect(AFaceRect.left, AFaceRect.top - iTextHeight
      - 6, max(AFaceRect.right, AFaceRect.left + iTextWidth + 10),
      AFaceRect.top, 0, 0);

    ACanvas.TextOut(Round((AFaceRect.left - iTextWidth) / 2),
      AFaceRect.top - 3 - iTextHeight, sText);
  end;

  // ����͸��
  if AAlphaBlend then
  begin
    DrawAlpha(ACanvas, AFaceRect.right, AFaceRect.bottom,
      AFaceRect.left + ACanvas.Pen.Width, AFaceRect.top +
      ACanvas.Pen.Width, AFaceRect.right - ACanvas.Pen.Width,
      AFaceRect.bottom - ACanvas.Pen.Width, 0, 0, ASourceConstantAlpha,
      ABlendColor);
  end;

  ACanvas.Refresh;

end;

// ��ȡAPI����������б�Delphi�����б�(����ģʽ)
class procedure TArcFaceSDK.ExtractFaceBoxs(AFaces: AFT_FSDK_FACERES;
  // ����λ�ÿ�ԭʼ����
  var AFaceRegions: TList<AFR_FSDK_FACEINPUT> // �ֽ�����б�
  );
var
  i, j: Integer;
  lFace: AFR_FSDK_FACEINPUT;
begin
  // if AFaceRegions = nil then
  // AFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  j := SizeOf(Integer);
  for i := 0 to AFaces.nFace - 1 do
  begin
    lFace.rcFace := pmrect(AFaces.rcFace + i * SizeOf(MRECT))^;
    // if AFaces.lfaceOrient < 100 then
    lFace.lOrient := AFaces.lfaceOrient;
    // else
    // lFace.lOrient := Pint(AFaces.lfaceOrient + i * j)^;
    AFaceRegions.Add(lFace);
  end;
end;

// ��ȡAPI����������б�Delphi�����б�
class procedure TArcFaceSDK.ExtractFaceBoxs(AFaces: AFD_FSDK_FACERES;
  // ����λ�ÿ�ԭʼ����
  AFaceRegions: TList<AFR_FSDK_FACEINPUT> // �ֽ�����б�
  );
var
  i, j: Integer;
  lFace: AFR_FSDK_FACEINPUT;
begin
  // if AFaceRegions = nil then
  // AFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  j := SizeOf(AFD_FSDK_OrientCode);
  for i := 0 to AFaces.nFace - 1 do
  begin
    lFace.rcFace := pmrect(AFaces.rcFace + i * SizeOf(MRECT))^;
    lFace.lOrient := Pint(AFaces.lfaceOrient + i * j)^;
    AFaceRegions.Add(lFace);
  end;
end;

// ��ȡAPI�������������б�����
class procedure TArcFaceSDK.ExtractFaceAges(AFaceAgeResults
  : ASAE_FSDK_AGERESULT; // ���g�����
  var AFaceAges: TArray<Integer> // �����������
  );
var
  i, j: Integer;
begin
  j := SizeOf(MInt32);
  SetLength(AFaceAges, AFaceAgeResults.lFaceNumber);
  for i := 0 to AFaceAgeResults.lFaceNumber - 1 do
    AFaceAges[i] := Pint(AFaceAgeResults.pAgeResultArray + i * j)^;
end;

// ��ȡAPI�����Ա������б�����
class procedure TArcFaceSDK.ExtractFaceGenders(AFaceGenderResults
  : ASGE_FSDK_GENDERRESULT; // �Ա�����
  var AFaceGenders: TArray<Integer> // �����������
  );
var
  i, j: Integer;
begin
  j := SizeOf(Integer);
  SetLength(AFaceGenders, AFaceGenderResults.lFaceNumber);
  for i := 0 to AFaceGenderResults.lFaceNumber - 1 do
  begin
    AFaceGenders[i] := Pint(AFaceGenderResults.pGenderResultArray + (i * j))^;
  end;
end;

// ���ݸ����ĵ�����������ȡ������������
function TArcFaceSDK.ExtractFaceFeature(AFaceInput: ASVLOFFSCREEN; // ͼƬ����
  AFaceRegion: AFR_FSDK_FACEINPUT; // ����λ����Ϣ
  var AFaceModel: AFR_FSDK_FACEMODEL // �������������������ڴ����ֶ�ʹ��freemem�ͷ�
  ): Boolean;
var
  tmpFaceModels: AFR_FSDK_FACEMODEL;
begin
  Result := false;
  if FFaceRecognitionEngine = nil then
    Exit;

  with AFaceModel do
  begin
    pbFeature := nil; // The extracted features
    lFeatureSize := 0;
  end;

  with tmpFaceModels do
  begin
    pbFeature := nil; // The extracted features
    lFeatureSize := 0;
  end;

  // ��ȡ��������
  Result := AFR_FSDK_ExtractFRFeature(FFaceRecognitionEngine, @AFaceInput,
    @AFaceRegion, tmpFaceModels) = MOK;
  if Result then
  begin
    AFaceModel.lFeatureSize := tmpFaceModels.lFeatureSize;
    GetMem(AFaceModel.pbFeature, AFaceModel.lFeatureSize);
    CopyMemory(AFaceModel.pbFeature, tmpFaceModels.pbFeature,
      AFaceModel.lFeatureSize);
  end;

end;

// ���ݸ����Ķ����������ȡ�����������
function TArcFaceSDK.ExtractFaceFeatures(AFaceInput: ASVLOFFSCREEN; // ͼƬ����
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ����λ����Ϣ��Ϣ�б�
  var AFaceModels: TFaceModels // ������������б�
  ): Boolean;
var
  lFaceModel: AFR_FSDK_FACEMODEL;
  i: Integer;
begin
  Result := false;
  if FFaceRecognitionEngine = nil then
    Exit;

  if AFaceModels = nil then
    AFaceModels := TFaceModels.Create;

  for i := 0 to AFaceRegions.Count - 1 do
    if ExtractFaceFeature(AFaceInput, AFaceRegions.Items[i], lFaceModel) then
      AFaceModels.AddModel(lFaceModel);
  Result := true;

end;

// ��Bitmap����ȡ������������
function TArcFaceSDK.ExtractFaceFeatureFromBmp(ABitmap: TBitmap; // Bitmap����
  AFaceRegion: AFR_FSDK_FACEINPUT; // ����λ����Ϣ
  var AFaceModel: AFR_FSDK_FACEMODEL // �������������������ڴ����ֶ�ʹ��freemem�ͷ�
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceRecognitionEngine = nil then
    Exit;

  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  // ����������ȡ
  Result := ExtractFaceFeature(offInput, AFaceRegion, AFaceModel);

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��Bitmap����ȡ�����������
function TArcFaceSDK.ExtractFaceFeaturesFromBmp(ABitmap: TBitmap; // ͼƬ����
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // ����λ����Ϣ��Ϣ�б�
  var AFaceModels: TFaceModels // ������������б�
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceRecognitionEngine = nil then
    Exit;

  if not ReadBmp(ABitmap, lImgDataInfo) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  // ����������ȡ
  Result := ExtractFaceFeatures(offInput, AFaceRegions, AFaceModels);

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��BMP�ļ�����ȡ������������
function TArcFaceSDK.ExtractFaceFeatureFromBmpFile(AFile: string;
  // BMPͼƬ�ļ�����ȷ���ļ���ʽΪBMP
  AFaceRegion: AFR_FSDK_FACEINPUT; // ����λ����Ϣ
  var AFaceModel: AFR_FSDK_FACEMODEL // �������������������ڴ����ֶ�ʹ��freemem�ͷ�
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceRecognitionEngine = nil then
    Exit;

  if not ReadBmpFile(AFile, lImgDataInfo) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  // ����������ȡ
  Result := ExtractFaceFeature(offInput, AFaceRegion, AFaceModel);

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��BMP�ļ�����ȡ�����������
function TArcFaceSDK.ExtractFaceFeaturesFromBmpFile(AFile: string; // BMPͼƬ�ļ�
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; // �������λ����Ϣ��Ϣ�б�
  var AFaceModels: TFaceModels // ������������б�
  ): Boolean;
var
  lImgDataInfo: TImgDataInfo;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := false;

  if FFaceRecognitionEngine = nil then
    Exit;

  if not ReadBmpFile(AFile, lImgDataInfo) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := lImgDataInfo.Width;
  offInput.i32Height := lImgDataInfo.Height;

  offInput.ppu8Plane[0] := IntPtr(lImgDataInfo.pImgData);
  offInput.pi32Pitch[0] := lImgDataInfo.LineBytes;

  // ����������ȡ
  Result := ExtractFaceFeatures(offInput, AFaceRegions, AFaceModels);

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// ��ʼ�������������
function TArcFaceSDK.InitialFaceDetectionEngine(Deinitial: Boolean): Integer;
begin

  if FFaceDetectionEngine <> nil then
  begin
    if Deinitial then
    begin
      // �ͷ�����
      Result := UnInitialFaceDetectionEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceDetectionBuf, FWorkKBufferSize);
  // ��ʼ������
  Result := AFD_FSDK_InitialFaceEngine(
    pansichar(AnsiString({$IFDEF RZSDK_AS_NORMAL}RZ_APPID_DLL{$ELSE} FAppID{$ENDIF} )), // [in]  APPID
    pansichar(AnsiString({$IFDEF RZSDK_AS_NORMAL}RZ_FaceDetectionKey_DLL{$ELSE}FFaceDetectionKey{$ENDIF})), // [in]  SDKKEY
    FpFaceDetectionBuf, // [in]	 User allocated memory for the engine
    FWorkKBufferSize, // WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceDetectionEngine, // [out] Pointing to the detection engine.
    // [in]  Defining the priority of face orientation
    ord(FOrientPriority),
    // [in]  An integer defining the minimal face to detect relative to the maximum of image width and height.
    FScale,
    // [in]  An integer defining the number of max faces to detection
    FMaxFace);

  if Result <> MOK then
  begin
    FreeMem(FpFaceDetectionBuf);
    FpFaceDetectionBuf := nil;
  end;

end;

// ��ʼ������׷������
function TArcFaceSDK.InitialFaceTrackingEngine(Deinitial: Boolean): Integer;
begin

  if FFaceTrackingEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceTrackingEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceTrackingBuf, FWorkKBufferSize);
  // ��ʼ��
  Result := AFT_FSDK_InitialFaceEngine(
    pansichar(AnsiString({$IFDEF RZSDK_AS_NORMAL} RZ_APPID_DLL{$ELSE}FAppID{$ENDIF})), // [in]  APPID
    pansichar(AnsiString({$IFDEF RZSDK_AS_NORMAL} RZ_FaceTrackingKey_DLL{$ELSE}FFaceTrackingKey{$ENDIF})), // [in]  SDKKEY
    FpFaceTrackingBuf, // [in]	 User allocated memory for the engine
    FWorkKBufferSize, // WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceTrackingEngine, // [out] Pointing to the Tracking engine.
    // [in]  Defining the priority of face orientation
    ord(FOrientPriority),
    // [in]  An integer defining the minimal face to detect relative to the maximum of image width and height.
    FScale,
    // [in]  An integer defining the number of max faces to Tracking
    FMaxFace);
  if Result <> MOK then
  begin
    FreeMem(FpFaceTrackingBuf);
    FpFaceTrackingBuf := nil;
  end;

end;

// ��ʼ������������ȡ����
function TArcFaceSDK.InitialFaceRecognitionEngine(Deinitial: Boolean): Integer;
begin

  if FFaceRecognitionEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceRecognitionEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceRecognitionBuf, FWorkKBufferSize);
  Result := AFR_FSDK_InitialEngine(
    pansichar(AnsiString({$IFDEF RZSDK_AS_NORMAL}FAPPID_FIC{$ELSE}FAppID{$ENDIF})), // [in]  APPID
    pansichar(AnsiString({$IFDEF RZSDK_AS_NORMAL}FFaceRZKey_FIC{$ELSE}FFaceRecognitionKey{$ENDIF})), // [in]  SDKKEY
    FpFaceRecognitionBuf, // [in]	 User allocated memory for the engine
    FWorkKBufferSize, // WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceRecognitionEngine);

  if Result <> MOK then
  begin
    FreeMem(FpFaceRecognitionBuf);
    FpFaceRecognitionBuf := nil;
  end;

end;

// ��ʼ����������������
function TArcFaceSDK.InitialFaceAgeEngine(Deinitial: Boolean): Integer;
begin

  if FFaceAgeEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceAgeEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceAgeBuf, FEstimationBufferSize);
  Result := ASAE_FSDK_InitAgeEngine(pansichar(AnsiString(FAppID)),
    // [in]  APPID
    pansichar(AnsiString(FFaceAgeKey)), // [in]  SDKKEY
    FpFaceAgeBuf, // [in]	 User allocated memory for the engine
    FEstimationBufferSize, // WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceAgeEngine);

  if Result <> MOK then
  begin
    FreeMem(FpFaceAgeBuf);
    FpFaceAgeBuf := nil;
  end;

end;

// ��ʼ����������������
function TArcFaceSDK.InitialFaceRzFicEngine(Deinitial: Boolean): Integer;
begin
{$IFDEF ARC_RZ_SDK}
  if FFaceRzFicEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceRzFicEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  Result := ArcSoft_FIC_InitialEngine(pansichar(AnsiString(FAPPID_FIC)),
    // [in]  APPID
    pansichar(AnsiString(FFaceRZKey_FIC)), // [in]  SDKKEY
    FFaceRzFicEngine);
{$ELSE}
  Result := MERR_UNKNOWN;
{$ENDIF}
end;

// ��ʼ�������Ա�������
function TArcFaceSDK.InitialFaceGenderEngine(Deinitial: Boolean): Integer;
begin

  if FFaceGenderEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceGenderEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceGenderBuf, FEstimationBufferSize);
  Result := ASGE_FSDK_InitGenderEngine(pansichar(AnsiString(FAppID)),
    // [in]  APPID
    pansichar(AnsiString(FFaceGenderKey)), // [in]  SDKKEY
    FpFaceGenderBuf, // [in]	 User allocated memory for the engine
    FEstimationBufferSize, // WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceGenderEngine);

  if Result <> MOK then
  begin
    FreeMem(FpFaceGenderBuf);
    FpFaceGenderBuf := nil;
  end;

end;

// �ȶ�������������
function TArcFaceSDK.MatchFace(AFaceModel1, AFaceModel2
  : AFR_FSDK_FACEMODEL): Single;
var
  fSimilScore: MFloat;
begin
  Result := 0;
  if FFaceRecognitionEngine = nil then
    Exit;

  // �Ա�����������������ñȶԽ��
  fSimilScore := 0.0;
  if AFR_FSDK_FacePairMatching(FFaceRecognitionEngine, @AFaceModel1,
    @AFaceModel2, fSimilScore) = MOK then
    Result := fSimilScore;
end;

// �ȶ�����ͼ��ֻȡ����ͼ��ĵ�һ���������бȶԣ�
function TArcFaceSDK.MatchFaceWithBitmaps(ABitmap1, ABitmap2: TBitmap): Single;
var
  AFaceRegions1, AFaceRegions2: TList<AFR_FSDK_FACEINPUT>;
  AFaceModels1, AFaceModels2: TFaceModels;
  i: Integer;
  T: Cardinal;
begin
  Result := 0;
  if (ABitmap1 = nil) or (ABitmap2 = nil) then
    Exit;

  AFaceRegions1 := TList<AFR_FSDK_FACEINPUT>.Create;
  AFaceRegions2 := TList<AFR_FSDK_FACEINPUT>.Create;
  AFaceModels1 := TFaceModels.Create;
  AFaceModels2 := TFaceModels.Create;
  try
{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    DetectAndRecognitionFacesFromBmp(ABitmap1, AFaceRegions1, AFaceModels1);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('ȡͼһ������ʱ��' + IntToStr(T));
{$ENDIF}
{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    DetectAndRecognitionFacesFromBmp(ABitmap2, AFaceRegions2, AFaceModels2);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('ȡͼ��������ʱ��' + IntToStr(T));
{$ENDIF}
    if (AFaceModels1.Count > 0) and (AFaceModels2.Count > 0) then
    begin
{$IFDEF DEBUG}
      T := GetTickCount;
{$ENDIF}
      Result := MatchFace(AFaceModels1.FaceModel[0], AFaceModels2.FaceModel[0]);
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

// �ͷ������������
function TArcFaceSDK.UnInitialFaceDetectionEngine: Integer;
begin

  if FFaceDetectionEngine <> nil then
  begin
    Result := AFD_FSDK_UninitialFaceEngine(FFaceDetectionEngine);
    if Result = MOK then
      FFaceDetectionEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceDetectionBuf <> nil then
  begin
    FreeMem(FpFaceDetectionBuf);
    FpFaceDetectionBuf := nil;
  end;

end;

// ��ȡBitmap����ͼ�����ݽṹ
class
  function TArcFaceSDK.ReadBmp(ABitmap: TBitmap;
  var AImgDataInfo: TImgDataInfo): Boolean;
var
  iLineByte: Integer;
  i: Integer;
  // ��ȡλ��
  function GetBitCount: Integer;
  begin
    case ABitmap.PixelFormat of
      pf1bit:
        Result := 1;
      pf4bit:
        Result := 4;
      pf8bit:
        Result := 8;
      pf15bit:
        Result := 16;
      pf16bit:
        Result := 16;
      pf24bit:
        Result := 24;
      pf32bit:
        Result := 32;
    else
      Result := 0;
    end;
  end;

begin
  Result := false;
  AImgDataInfo.Init;
  AImgDataInfo.BitCount := GetBitCount;
  if AImgDataInfo.BitCount = 0 then
    Exit;

  AImgDataInfo.Width := ABitmap.Width;
  AImgDataInfo.Height := ABitmap.Height;

  // ��ȡλͼ�г���
  iLineByte := Trunc((ABitmap.Width * AImgDataInfo.BitCount / 8 + 3) / 4) * 4;
  AImgDataInfo.LineBytes := iLineByte;

  GetMem(AImgDataInfo.pImgData, iLineByte * ABitmap.Height);

  // �����ڴ棬ע��Ϊ���򣬴����һ�п�ʼ��
  for i := ABitmap.Height - 1 downto 0 do
  begin
    CopyMemory(Pointer(AImgDataInfo.pImgData + i * iLineByte),
      ABitmap.ScanLine[i], iLineByte);
  end;

  Result := true;
end;

// ��ȡ�����ϵ�BMP�ļ���ͼ�����ݽṹ
class
  function TArcFaceSDK.ReadBmpFile(AFileName: string;
  var AImgDataInfo: TImgDataInfo): Boolean;
var
  lBitmap: TBitmap;
begin

  Result := false;
  if not FileExists(AFileName) then
    Exit;

  lBitmap := TBitmap.Create;
  try
    lBitmap.LoadFromFile(AFileName);
    Result := ReadBmp(lBitmap, AImgDataInfo);
  finally
    lBitmap.Free;
  end;

end;

// ��ȡ�����ϵ�BMP�ļ����ڴ沢ת��ΪTBitmap
class
  function TArcFaceSDK.ReadBmpFile(AFileName: string;
  ABitmap: TBitmap): Boolean;
begin

  Result := false;
  if not FileExists(AFileName) then
    Exit;

  ABitmap.LoadFromFile(AFileName);
  Result := true;

end;

// ��ȡ�����ϵ�JPG�ļ����ڴ沢ת��ΪTBitmap
class
  function TArcFaceSDK.ReadJpegFile(AFileName: string;
  var AImgDataInfo: TImgDataInfo): Boolean;
var
  lBitmap: TBitmap;
  lJpeg: TuJpegImage;
begin

  Result := false;
  if not FileExists(AFileName) then
    Exit;
  lJpeg := TuJpegImage.Create;

  try
    lJpeg.LoadFromFile(AFileName);
    lBitmap := lJpeg.BitmapData;
    Result := ReadBmp(lBitmap, AImgDataInfo);
  finally
    lBitmap := nil;
    lJpeg.Free;
  end;

end;

// ��ȡBMP����ͼ�����ݽṹ
class
  function TArcFaceSDK.ReadBmpStream(AStream: TMemoryStream;
  var AImgDataInfo: TImgDataInfo): Boolean;
var
  lBitmap: TBitmap;
begin

  Result := false;
  if AStream = nil then
    Exit;

  lBitmap := TBitmap.Create;
  try
    lBitmap.LoadFromStream(AStream);
    Result := ReadBmp(lBitmap, AImgDataInfo);
  finally
    lBitmap.Free;
  end;

end;

// ��ȡ�����ϵ�JPG�ļ����ڴ沢ת��ΪTBitmap
class
  function TArcFaceSDK.ReadJpegFile(AFileName: string;
  ABitmap: TBitmap): Boolean;
var
  lJpeg: TuJpegImage;
begin

  Result := false;
  if not FileExists(AFileName) then
    Exit;
  lJpeg := TuJpegImage.Create;
  try
    lJpeg.LoadFromFile(AFileName);
    ABitmap.Assign(lJpeg.BitmapData);
    Result := true;
  finally
    lJpeg.Free;
  end;

end;

{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicCompareFromBmp
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:
  AZjz,//����֤��Ƭ
  ARyZP: TBitmap; //��Աץ����
  isVideo: Boolean;
  var ASimilarScore: Single;
  var ACompareResult: Integer;
  var AFaceRes: AFIC_FSDK_FACERES;
  AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicCompareFromBmp(AZjz, ARyZP: TBitmap;
  isVideo: Boolean;
  var ASimilarScore: Single; var ACompareResult: Integer;
  var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean;
begin
  Result := false;
  if RzFicIdCardDataFeatureExtractionFromBmp(AZjz) then
    if RzFicFaceDataFeatureExtractionFromBmp(ARyZP, isVideo, AFaceRes) then
      Result := RzFicFaceIdCardCompare(ASimilarScore, ACompareResult,
        AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmp
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��λͼ����ȡ������������������λ�ã���һ������ʹ����֤SDK����
  ����:
  ARyZP: TBitmap; //Դλͼ
  isVideo: Boolean //�Ƿ�Ϊ��Ƶģʽ
  var AFaceRes: AFIC_FSDK_FACERES //����λ����Ϣ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmp(ABitmap: TBitmap;
  isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES): Boolean;
var
  lRyzpData: TImgDataInfo;
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
  if not ReadBmp(ABitmap, lRyzpData) then
    Exit;

{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  RyZPInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(RyZPInput.pi32Pitch, SizeOf(RyZPInput.pi32Pitch), 0);
  FillChar(RyZPInput.ppu8Plane, SizeOf(RyZPInput.ppu8Plane), 0);

  RyZPInput.i32Width := lRyzpData.Width;
  RyZPInput.i32Height := lRyzpData.Height;

  RyZPInput.ppu8Plane[0] := IntPtr(lRyzpData.pImgData);
  RyZPInput.pi32Pitch[0] := lRyzpData.LineBytes;

  // �������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := ArcSoft_FIC_FaceDataFeatureExtraction(FFaceRzFicEngine,
    // [in]  FIC ����Handle
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
  if lRyzpData.pImgData <> nil then
    FreeMem(lRyzpData.pImgData);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmp
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��λͼ����ȡ��������������������λ�ã�ʹ����֤SDK����
  ����:
  ARyZP: TBitmap; //Դλͼ
  isVideo: Boolean //�Ƿ�Ϊ��Ƶģʽ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmp(ARyZP: TBitmap;
  isVideo: Boolean): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicFaceDataFeatureExtractionFromBmp(ARyZP, isVideo, lFaceRes);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmpFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��λͼ�ļ�����ȡ������������������λ�ã���һ���� ��ʹ����֤SDK����
  ����:
  AFile: String; //Դ�ļ�ȫ·��
  isVideo: Boolean; //�Ƿ�Ϊ��Ƶģʽ
  var AFaceRes: AFIC_FSDK_FACERES //����λ����Ϣ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmpFile(AFile: String;
  isVideo: Boolean; var AFaceRes: AFIC_FSDK_FACERES): Boolean;
var
  lBitmap: TBitmap;
begin
  Result := false;
  lBitmap := TBitmap.Create;
  try
    if ReadBmpFile(AFile, lBitmap) then
      Result := RzFicFaceDataFeatureExtractionFromBmp(lBitmap, isVideo,
        AFaceRes);
  finally
    lBitmap.Free;
  end;
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmpFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��λͼ�ļ�����ȡ��������������������λ�ã�ʹ����֤SDK����
  ����:
  AFile: String; //Դ�ļ�ȫ·��
  isVideo: Boolean //�Ƿ�Ϊ��Ƶģʽ
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicFaceDataFeatureExtractionFromBmpFile(AFile: String;
  isVideo: Boolean): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicFaceDataFeatureExtractionFromBmpFile(AFile, isVideo,
    lFaceRes);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicIdCardDataFeatureExtractionFromBmp
  ����:      NJTZ
  ����:      2018.09.23
  ����:      �Ӷ���֤��Ƭλͼ����ȡ����������ʹ����֤SDK����
  ����:      ABitmap: TBitmap
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicIdCardDataFeatureExtractionFromBmp(ABitmap: TBitmap):
  Boolean;
var
  lImgData: TImgDataInfo;
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
  if not ReadBmp(ABitmap, lImgData) then
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

  nRet := ArcSoft_FIC_IdCardDataFeatureExtraction(FFaceRzFicEngine,
    // [in]  FIC ����Handle
    @offInput // [in]  ͼ��ԭʼ����
    );

  Result := nRet = MOK;

  if lImgData.pImgData <> nil then
    FreeMem(lImgData.pImgData);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicFaceIdCardCompare
  ����:      NJTZ
  ����:      2018.09.23
  ����:
  �ȶԶ���֤оƬ��Ƭ������ץ����Ƭ��������ʹ����֤SDK����
  ʹ�øú���ǰ������ִ��RzFicFaceDataFeatureExtractionFromBmp
  ��RzFicIdCardDataFeatureExtractionFromBmp������ͬ���ܺ�������������
  ����:
  var ASimilarScore: Single; //���ƶ�
  var ACompareResult: Integer;  //�ȶԽ�������� Athresholdֵ�� ASimilarScoreֵ
  //���бȽϣ�ASimilarScore >= AThreshold ��Ϊ1������Ϊ0
  AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicFaceIdCardCompare(var ASimilarScore: Single;
  var ACompareResult: Integer; AThreshold: Single = 0.82): Boolean;
var
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := false;

  if FFaceRzFicEngine = nil then
    Exit;

  nRet := ArcSoft_FIC_FaceIdCardCompare(FFaceRzFicEngine,
    // [in] FIC ����Handle
    AThreshold, // [in]  �ȶ���ֵ
    ASimilarScore, // [out] �ȶԽ�����ƶ�
    ACompareResult // [out] �ȶԽ��
    );

  Result := nRet = MOK;
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicCompareFromBmp
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:
  AZjz,
  ARyZP: TBitmap;
  isVideo: Boolean;
  var ASimilarScore: Single;
  var ACompareResult: Integer;
  AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicCompareFromBmp(AZjz, ARyZP: TBitmap; isVideo:
  Boolean; var ASimilarScore: Single; var ACompareResult: Integer;
  AThreshold: Single = 0.82): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicCompareFromBmp(AZjz, ARyZP, isVideo, ASimilarScore,
    ACompareResult,
    lFaceRes, AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicCompareFromBmpFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:      AZjzFile, ARyZPFile: string; isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer; var AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicCompareFromBmpFile(AZjzFile, ARyZPFile: string;
  isVideo:
  Boolean; var ASimilarScore: Single; var ACompareResult: Integer; var
  AFaceRes: AFIC_FSDK_FACERES; AThreshold: Single = 0.82): Boolean;
begin
  Result := false;
  if RzFicIdCardDataFeatureExtractionFromBmpFile(AZjzFile) then
    if RzFicFaceDataFeatureExtractionFromBmpFile(ARyZPFile, isVideo, AFaceRes)
    then
      Result := RzFicFaceIdCardCompare(ASimilarScore, ACompareResult,
        AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicCompareFromBmpFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      ��������ץ���պͶ���֤��Ƭ���һ����������֤�ȶԹ��̣�ʹ����֤SDK����
  ����:      AZjzFile, ARyZPFile: string; isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer; AThreshold: Single = 0.82
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicCompareFromBmpFile(AZjzFile, ARyZPFile: string;
  isVideo: Boolean; var ASimilarScore: Single; var ACompareResult: Integer;
  AThreshold: Single = 0.82): Boolean;
var
  lFaceRes: AFIC_FSDK_FACERES;
begin
  Result := RzFicCompareFromBmpFile(AZjzFile, ARyZPFile, isVideo,
    ASimilarScore,
    ACompareResult, lFaceRes, AThreshold);
end;
{$ENDIF}
{ -------------------------------------------------------------------------------
  ������:    TArcFaceSDK.RzFicIdCardDataFeatureExtractionFromBmpFile
  ����:      NJTZ
  ����:      2018.09.23
  ����:      �Ӷ���֤��Ƭ�ļ�����ȡ����������ʹ����֤SDK����
  ����:      AFile: string
  ����ֵ:    Boolean
  ------------------------------------------------------------------------------- }
{$IFDEF ARC_RZ_SDK}


function TArcFaceSDK.RzFicIdCardDataFeatureExtractionFromBmpFile(AFile:
  string): Boolean;
var
  lBitmap: TBitmap;
begin
  Result := false;
  lBitmap := TBitmap.Create;
  try
    if ReadBmpFile(AFile, lBitmap) then
      Result := RzFicIdCardDataFeatureExtractionFromBmp(lBitmap);
  finally
    lBitmap.Free;
  end;
end;
{$ENDIF}


procedure TArcFaceSDK.SetMaxFace(const Value: Integer);
begin
  FMaxFace := Value;
end;

procedure TArcFaceSDK.SetScale(const Value: Integer);
begin
  FScale := Value;
end;

// ��Bitmap�л�ȡ����λ�á��Ա��������Ϣ�б�׷��ģʽ��
function TArcFaceSDK.TrackFacesAndAgeGenderFromBmp(ABitmap: TBitmap; // Դλͼ
  var AFaceInfos: TList<TFaceBaseInfo> // �������������Ϣ
  ): Boolean;
var
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
  lImgDataInfo: TImgDataInfo;
  ArrFaceOrient: array of AFT_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
  R: MRESULT;
begin
  Result := false;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  if not ReadBmp(ABitmap, lImgDataInfo) then
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

          if ASAE_FSDK_AgeEstimation_Preview(FFaceAgeEngine,
            // [in] age estimation engine
            @offInput, // [in] the original image information
            // [in] the face rectangles information
            @lFaceRes_Age,
            // [out] the results of age estimation
            lAgeRes) = MOK then
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

          if ASGE_FSDK_GenderEstimation_Preview(FFaceGenderEngine,
            // [in] Gender estimation engine
            @offInput, // [in] the original imGender information
            // [in] the face rectangles information
            @lFaceRes_Gender,
            // [out] the results of Gender estimation
            lGenderRes) = MOK then
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

  if lImgDataInfo.pImgData <> nil then
    FreeMem(lImgDataInfo.pImgData);

end;

// �ͷ�������������
function TArcFaceSDK.UnInitialFaceTrackingEngine: Integer;
begin
  if FFaceTrackingEngine <> nil then
  begin
    Result := AFT_FSDK_UninitialFaceEngine(FFaceTrackingEngine);
    if Result = MOK then
      FFaceTrackingEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceTrackingBuf <> nil then
  begin
    FreeMem(FpFaceTrackingBuf);
    FpFaceTrackingBuf := nil;
  end;

end;

// �ͷ��������ʶ������
function TArcFaceSDK.UnInitialFaceRecognitionEngine: Integer;
begin
  if FFaceRecognitionEngine <> nil then
  begin
    Result := AFR_FSDK_UninitialEngine(FFaceRecognitionEngine);
    if Result = MOK then
      FFaceRecognitionEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceRecognitionBuf <> nil then
  begin
    FreeMem(FpFaceRecognitionBuf);
    FpFaceRecognitionBuf := nil;
  end;

end;

// �ͷ�����ʶ������
function TArcFaceSDK.UnInitialFaceAgeEngine: Integer;
begin
  if FFaceAgeEngine <> nil then
  begin
    Result := ASAE_FSDK_UninitAgeEngine(FFaceAgeEngine);
    if Result = MOK then
      FFaceAgeEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceAgeBuf <> nil then
  begin
    FreeMem(FpFaceAgeBuf);
    FpFaceAgeBuf := nil;
  end;

end;

// �ͷ�����ʶ������
function TArcFaceSDK.UnInitialFaceRzFicEngine: Integer;
begin
{$IFDEF RZ_SDK}
  if FFaceRzFicEngine <> nil then
  begin
    Result := ArcSoft_FIC_UninitialEngine(FFaceRzFicEngine);
    if Result = MOK then
      FFaceRzFicEngine := nil;
  end
  else
{$ENDIF}
    Result := MOK;
end;

// �ͷ��Ա�ʶ������
function TArcFaceSDK.UnInitialFaceGenderEngine: Integer;
begin
  if FFaceGenderEngine <> nil then
  begin
    Result := ASGE_FSDK_UninitGenderEngine(FFaceGenderEngine);
    if Result = MOK then
      FFaceGenderEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceGenderBuf <> nil then
  begin
    FreeMem(FpFaceGenderBuf);
    FpFaceGenderBuf := nil;
  end;

end;

constructor TFaceModels.Create;
begin
  inherited;
  FModels := TList<AFR_FSDK_FACEMODEL>.Create;
  FChanged := false;
end;

destructor TFaceModels.Destroy;
begin
  Clear;
  FModels.Free;
  inherited;
end;

function TFaceModels.AddModel(AModel: AFR_FSDK_FACEMODEL): Integer;
begin
  Result := FModels.Add(AModel);
  FChanged := true;
end;

procedure TFaceModels.Assign(ASource: TFaceModels);
begin
  Clear;
  AddModels(ASource);
end;

procedure TFaceModels.AddModels(ASource: TFaceModels);
var
  i: Integer;
  lSourceModel, lDestModel: AFR_FSDK_FACEMODEL;
begin
  for i := 0 to ASource.Count - 1 do
  begin
    lSourceModel := ASource.FaceModel[i];

    lDestModel.lFeatureSize := lSourceModel.lFeatureSize;
    GetMem(lDestModel.pbFeature, lDestModel.lFeatureSize);
    CopyMemory(lDestModel.pbFeature, lSourceModel.pbFeature,
      lDestModel.lFeatureSize);

    FModels.Add(lDestModel);
  end;

end;

procedure TFaceModels.Clear;
var
  i: Integer;
begin
  if FModels.Count > 0 then
  begin
    for i := FModels.Count - 1 downto 0 do
    begin
      if FModels.Items[i].pbFeature <> nil then
      begin
        FreeMem(FModels.Items[i].pbFeature);
      end;
      FModels.Delete(i);
    end;
    FChanged := true;
  end;
end;

procedure TFaceModels.Delete(Index: Integer);
begin
  if (Index >= 0) and (Index < FModels.Count) then
  begin
    if FModels.Items[Index].pbFeature <> nil then
      FreeMem(FModels.Items[Index].pbFeature);
    FModels.Delete(Index);
    FChanged := true;
  end;
end;

function TFaceModels.GetCount: Integer;
begin
  Result := FModels.Count;
end;

function TFaceModels.GetFaceModel(Index: Integer): AFR_FSDK_FACEMODEL;
begin
  Result.lFeatureSize := 0;
  Result.pbFeature := nil;
  if (Index >= 0) and (Index < FModels.Count) then
    Result := FModels.Items[Index];
end;

function TFaceModels.GetItems(Index: Integer): AFR_FSDK_FACEMODEL;
begin
  Result.lFeatureSize := 0;
  Result.pbFeature := nil;
  if (Index >= 0) and (Index < FModels.Count) then
    Result := FModels.Items[Index];
end;

procedure TFaceModels.ResetState;
begin
  FChanged := false;
end;

function TuJpegImage.BitmapData: TBitmap;
begin
  Result := Bitmap;
end;

constructor TEdzFaceModels.Create;
begin
  inherited;
  FRyID := '';
  FParams := '';
  FBitmap := TBitmap.Create;
end;

destructor TEdzFaceModels.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TEdzFaceModels.Assign(ASource: TFaceModels);
begin
  inherited;
  if ASource is TEdzFaceModels then
  begin
    with TEdzFaceModels(ASource) do
    begin
      Self.FRyID := RyID;
      Self.FParams := Params;
      Self.FBitmap.Assign(Bitmap);
    end;
    FChanged := true;
  end;
end;

procedure TEdzFaceModels.Clear;
var
  i: Integer;
begin
  inherited;
  if FRyID <> '' then
  begin
    FRyID := '';
    FChanged := true;
  end;
  if FParams <> '' then
  begin
    FParams := '';
    FChanged := true;
  end;
end;

procedure TEdzFaceModels.SetBitmap(const Value: TBitmap);
begin
  FBitmap.Assign(Value);
  FChanged := true;
end;

procedure TEdzFaceModels.SetParams(const Value: String);
begin
  if FParams <> Value then
  begin
    FParams := Value;
    FChanged := true;
  end;
end;

procedure TEdzFaceModels.SetRyID(const Value: String);
begin
  if FRyID <> Value then
  begin
    FRyID := Value;
    FChanged := true;
  end;
end;

procedure TFaceBaseInfo.Init;
begin
  Age := 0;
  Gender := 0;
  FaceOrient := 0;
  with FaceRect do
  begin
    left := 0;
    right := 0;
    top := 0;
    bottom := 0;
  end;
end;

procedure TFaceFullInfo.Init;
begin
  Age := 0;
  Gender := 0;
  FaceOrient := 0;
  with FaceRect do
  begin
    left := 0;
    right := 0;
    top := 0;
    bottom := 0;
  end;

end;

procedure TImgDataInfo.Init;
begin
  pImgData := nil;
  Width := 0;
  Height := 0;
  LineBytes := 0;
  BitCount := 0;
end;

end.
