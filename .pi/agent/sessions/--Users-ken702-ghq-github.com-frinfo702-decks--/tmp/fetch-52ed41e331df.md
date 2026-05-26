# Segmentation全体としての分野

セグメンテーション全体は**入力データの種類**と**タスクの種類**で大きく2つの軸に分けられる

## 第1軸: タスクの種類による分類[\[1\]](#fn-1)

task

definition

output format

main approach

Semantic Segmentation

各ピクセルにクラスラベルを付与。同一クラスの複数インスタンスは区別しない

ピクセル単位のクラスマップ

FCN, U-Net, DeepLab, PSPNet, SegFormer

Instance Segmentation

各インスタンス（個体）をクラスラベル付きで分離。重なりを許容

マスク + クラス + インスタンスID

Mask R-CNN, YOLACT, SOLO, Mask2Former, DETR

Panoptic Segmentation

Semantic + Instance。全ピクセルにクラスラベルとインスタンスIDを付与。重なりなし

統合マップ（PQで評価）

Panoptic-DeepLab, Mask2Former, VPSNet

Video Object Segmentation

動画中の特定オブジェクトをフレーム間で追跡しマスク化

時系列マスク

XMem, STCN, SAM 2/3 Video

Video Semantic/Instance/Panoptic

動画版の各種セグメンテーション。時間的一貫性が要件

時系列マップ

VSS, VIS, VPS（Video Scene Parsing）

```text
セグメンテーション
├── 2D自然画像・一般物体
│   ├── Semantic
│   ├── Instance
│   ├── Panoptic
│   └── Interactive / Referring（対話型・言語参照）
├── Video Scene Parsing (VSP)
│   ├── Semantic (VSS)
│   │   ├── テンポラルコンシステンシ重視
│   │   └── 代表: STM, TempNet, Video DeepLab
│   ├── Instance (VIS)
│   │   ├── Online（逐次処理）: MaskTrack R-CNN, SipMask
│   │   └── Offline（全フレーム利用）: STMask, IFC
│   ├── Panoptic (VPS)
│   │   ├── Dual-branch（Semantic + Instanceを分離統合）: Panoptic-DeepLab, VPSNet
│   │   └── Depth-aware（深度推論と統合）: ViP-DeepLab, PolyphonicFormer
│   ├── Tracking & Segmentation (VTS)
│   │   ├── VOS（1次参照）: XMem, STCN, SAM 2/3 Video
│   │   └── RVOS（言語参照動画）: MTTR, SeC (ICLR 2026)
│   └── Open-Vocabulary (OVVS)
│       └── テキスト/画像クエリによるゼロショット動画セグメンテーション
├── 3D・点群
│   ├── Semantic Segmentation（屋外・屋内シーン）
│   ├── Instance Segmentation
│   └── Part Segmentation（部品レベル）
└── 特殊ドメイン
    ├── 医療画像
    │   ├── 2D / 2.5D（RGB-D, CT image）
    │   ├── 3D体積（Volume）
    │   └── 細胞・組織レベル（Instance）
    ├── リモートセンシング・衛星画像
    ├── 自動運転（LiDAR + RGB fusion）
    └── 極限環境（悪天候・低照度）
```

```text
セグメンテーション
├── 2D自然画像・一般物体
│   ├── Semantic
│   ├── Instance
│   ├── Panoptic
│   └── Interactive / Referring（対話型・言語参照）
├── Video Scene Parsing (VSP)
│   ├── Semantic (VSS)
│   │   ├── テンポラルコンシステンシ重視
│   │   └── 代表: STM, TempNet, Video DeepLab
│   ├── Instance (VIS)
│   │   ├── Online（逐次処理）: MaskTrack R-CNN, SipMask
│   │   └── Offline（全フレーム利用）: STMask, IFC
│   ├── Panoptic (VPS)
│   │   ├── Dual-branch（Semantic + Instanceを分離統合）: Panoptic-DeepLab, VPSNet
│   │   └── Depth-aware（深度推論と統合）: ViP-DeepLab, PolyphonicFormer
│   ├── Tracking & Segmentation (VTS)
│   │   ├── VOS（1次参照）: XMem, STCN, SAM 2/3 Video
│   │   └── RVOS（言語参照動画）: MTTR, SeC (ICLR 2026)
│   └── Open-Vocabulary (OVVS)
│       └── テキスト/画像クエリによるゼロショット動画セグメンテーション
├── 3D・点群
│   ├── Semantic Segmentation（屋外・屋内シーン）
│   ├── Instance Segmentation
│   └── Part Segmentation（部品レベル）
└── 特殊ドメイン
    ├── 医療画像
    │   ├── 2D / 2.5D（RGB-D, CT image）
    │   ├── 3D体積（Volume）
    │   └── 細胞・組織レベル（Instance）
    ├── リモートセンシング・衛星画像
    ├── 自動運転（LiDAR + RGB fusion）
    └── 極限環境（悪天候・低照度）
```

## 第2軸: 入力データの種類

```text
セグメンテーション
├── 2D自然画像・一般物体
│   ├── RGB
│   ├── マルチスペクトル
├── 動画
│   ├── 時系列2D (VSS)
├── 3D
│   ├── 点群
│   ├── ボクセル
│   └── メッシュ
└── 特殊ドメイン
    ├── 医療画像
    │   ├── CT
    │   ├── MRI
    │   ├── 内視鏡
    │   └── 病理
    ├── リモートセンシング
    │   ├── 衛星写真
    │   └── 航空写真
    ├── 自動運転
    │   ├── LIDAR+RGB
    │   └── レーダー
    ├── 工場・製造
    └── 極限環境（悪天候・低照度）

```

```text
セグメンテーション
├── 2D自然画像・一般物体
│   ├── RGB
│   ├── マルチスペクトル
├── 動画
│   ├── 時系列2D (VSS)
├── 3D
│   ├── 点群
│   ├── ボクセル
│   └── メッシュ
└── 特殊ドメイン
    ├── 医療画像
    │   ├── CT
    │   ├── MRI
    │   ├── 内視鏡
    │   └── 病理
    ├── リモートセンシング
    │   ├── 衛星写真
    │   └── 航空写真
    ├── 自動運転
    │   ├── LIDAR+RGB
    │   └── レーダー
    ├── 工場・製造
    └── 極限環境（悪天候・低照度）

```

## データセット

### 2D自然画像・一般物体

データセット

規模・特徴

対応タスク

備考

**PASCAL VOC 2012**

~11,500画像, 20クラス

Semantic, Instance

古典的ベンチマーク

**PASCAL Context**

10,103画像, 540ラベル

Semantic

高密度注釈。

**MS COCO**

330K画像, 80 thing + 91 stuff

Instance, Panoptic, Semantic

インスタンス分割のデファクトスタンダード。

**ADE20K**

25K画像, 150クラス（100 thing + 50 stuff）

Semantic, Panoptic

シーン理解の高密度注釈。

**Cityscapes**

5,000画像（2,975 train, 500 val, 1,525 test）, 19クラス

Semantic, Instance, Panoptic

自動運転向け。97%ピクセルカバレッジ。

**Mapillary Vistas**

25K画像, 65クラス（37 thing + 28 stuff）

Semantic, Panoptic, Instance

グローバルな街並み。98%カバレッジ。

**BDD100K**

100K動画, 10タスク

Semantic, Instance, 動画

多様な天候・時間帯。

**KITTI**

自動運転センサーデータ

Semantic

LiDAR + RGB。

**BSDS500**

1,000画像 × 30人の注釈

古典的分割・境界検出

人間の多様性を含む。

### Video Scene Parsing (VSP)

データセット

規模・特徴

対応タスク

**DAVIS**

高品質な動画オブジェクトセグメンテーション

VOS

**YouTube-VOS**

大規模動画インスタンスセグメンテーション

VIS, VOS

**VIPSeg**

動画パノプティックセグメンテーション

VPS

**Cityscapes-VPS**

Cityscapesの動画版

VPS, VSS

**BDD100K**

動画セマンティックセグメンテーション

VSS

**MOSE / MOSE v2**

動画オブジェクトセグメンテーション

VOS（困難シーン）

**Long-RVOS**

長期間リファリング動画セグメンテーション

RVOS

### 3D・点群

データセット

規模・特徴

対応タスク

**ModelNet40**

40カテゴリ, CADモデル

Classification, Part Seg

**ShapeNet**

55カテゴリ, 51,300モデル

Part Segmentation

**S3DIS**

屋内シーン, 6領域, 13クラス

Semantic Seg

**ScanNet**

1,500屋内シーン, 40クラス

Semantic, Instance

**ScanNet200**

ScanNetの200クラス拡張

Semantic（細粒度）

**SemanticKITTI**

自動運転LiDAR, 22シーケンス, 19クラス

Semantic Seg

**nuScenes**

自動運転, 360°カメラ + LiDAR + レーダー

Semantic, Panoptic, 3D Detection

### 医療画像

データセット

モダリティ

対象

**BraTS**

MRI（FLAIR, T1, T1ce, T2）

脳腫瘍

**LiTS**

CT

肝臓・肝がん

**ACDC**

MRI

心臓

**Kvasir-SEG**

内視鏡画像

消化管

**MoNuSeg**

H&E染色組織病理画像

細胞核

**TNBC**

三重陰性乳がん病理画像

細胞

**BTCV**

CT

腹部臓器

**TotalSegmentator**

CT

104解剖学的構造

## 評価指標

### Semantic Segmentation

指標

定義

特徴

**Pixel Accuracy**

正しく分類されたピクセル / 全ピクセル

クラス不均衡に弱い

**Mean Accuracy**

各クラスのAccuracyの平均

不均衡にやや強い

**Mean IoU (mIoU / Jaccard Index)**

各クラスのIoU \\(\\frac{TP}{TP + FP + FN}\\) の平均

**最も標準的**。PASCAL VOCで普及。

**Frequency Weighted IoU**

クラス出現頻度で重み付けしたIoU

頻出クラスを重視

**Dice Coefficient (F1-score)**

\\(\\frac{2\\text{TP}}{2\\text{TP} + \\text{FP} + \\text{FN}}\\)

医療画像で多用。境界の重複を重視。

### Instance Segmentation

指標

定義

特徴

**Average Precision (AP)**

IoU閾値（通常0.5）でのPrecision-Recall曲線下面積

COCOの標準。Confidence scoreを必要とする。

**AP@0.5 (AP50)**

IoU > 0.5 でのAP

緩い評価

**AP@0.75 (AP75)**

IoU > 0.75 でのAP

厳しい評価

**AP@\[.5:.95\]**

IoU 0.5〜0.95で平均したAP

COCOの主要メトリクス

**mAP**

複数クラスでのAP平均

### Panoptic Segmentation

指標

定義

特徴

**Panoptic Quality (\\(PQ\\))**

\\(PQ = SQ \\times RQ\\)

**統一指標**。StuffとThingsを等しく扱う。

**Segmentation Quality (\\(SQ\\))**

マッチしたセグメントの平均IoU

分割の精密さ

**Recognition Quality (\\(RQ\\))**

マッチしたセグメントのF1-score

検出・認識の精度

**Weighted PQ (wPQ)**

クラス頻度で重み付けした \\(PQ\\)

URVIS 2026などで採用

### 動画

指標

適用タスク

定義

**Region Similarity (J / IoU)**

VOS

フレーム間マスクのIoU平均

**Contour Accuracy (F)**

VOS

境界のF-measure

**Temporal Stability (T)**

VOS

時間的な揺らぎの少なさ

**Video Panoptic Quality (VPQ)**

VPS

動画版PQ。時間軸での一貫性を含む

**MOTA / MOTP**

\\(\\frac{\\text{VOS}}{\\text{VIS}}\\)

追跡性能（Multiple Object Tracking）

### 3D点群

指標

定義

**Overall Accuracy (OA)**

全点の正解率

**Mean IoU (mIoU)**

クラスごとのIoU平均（2Dと同様）

**Mean Class Accuracy**

クラスごとの正解率平均

### 医療画像

指標

用途

**Hausdorff Distance (HD)**

予測境界とGT境界の最大距離。境界の外れを厳しく評価。

**Average Surface Distance (ASD)**

境界間の平均距離。

**Sensitivity / Specificity**

病変検出の漏れ・過検出のバランス。

**Dice Score**

体積の重なり。医療で最も一般的。

# Open-Vocablary segmentationサーベイでの分類

-   Training Free Open-Vocabulary Semantic Segmentation
    -   CLIP-Based Approaches
        -   Purely CLIP-based
            -   Refine Inter-token Mixing
            -   Leverage Intermediate Layers
            -   Leverage Non-ML obtained Masks
            -   Others
        -   VFM-s alongside CLIP
            -   Refine Inter-token Mixing with VFMs
            -   Leverage VFMs for Maskpooling
        -   Generative Methods Alongside CLIP