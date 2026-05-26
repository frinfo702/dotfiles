[frinfo702](/frinfo702) / **[ov-seg](/frinfo702/ov-seg)** Public

forked from [facebookresearch/ov-seg](/facebookresearch/ov-seg)

-   [Notifications](/login?return_to=%2Ffrinfo702%2Fov-seg) You must be signed in to change notification settings
-   [Fork 0](/login?return_to=%2Ffrinfo702%2Fov-seg)
-   [Star 0](/login?return_to=%2Ffrinfo702%2Fov-seg)
    

## Conversation

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=80&v=4)](/frinfo702)

Copy link

Copy Markdown

Owner

### 

 ![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=48&v=4)**[frinfo702](/frinfo702)** commented [May 17, 2026](#issue-4462794995)

This pull request introduces the new OVSAM-Seg architecture, which replaces MaskFormer with SAM3 for mask proposal generation in open-vocabulary semantic segmentation. The changes include a new configuration file for OVSAM-Seg, a detailed implementation plan, and the addition of MaskFormer model code. The update also includes packaging files for the `open_clip` library, which is used for CLIP-based classification.

**Key changes:**

### OVSAM-Seg Architecture and Implementation

-   Added a comprehensive implementation plan for OVSAM-Seg, detailing its motivation, architecture, file structure, and step-by-step development process. This document explains how SAM3 is integrated as a mask proposal generator and how it interacts with the CLIP adapter for open-vocabulary segmentation.
-   Introduced a new configuration file `ovsam_seg_swinB_vitL.yaml` that specifies model parameters, datasets, solver settings, and input preprocessing for OVSAM-Seg, enabling easy experimentation and evaluation.

### Model Code Additions

-   Added the full implementation of the `MaskFormer` model in `mask_former_model.py`, including configuration, training, inference, and loss calculation logic. This provides a reference or base for comparison with the new OVSAM-Seg model.

### Packaging and Dependency Management

-   Added packaging files for the `open_clip` library, including `SOURCES.txt`, `requires.txt`, and related metadata files, which declare dependencies such as `torch`, `torchvision`, `ftfy`, `regex`, and `tqdm`. These are necessary for CLIP-based image-text processing in the new architecture. [\[1\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-a2b2c4286e380d534e4bd7da686261e64b653e0578377c83bd8e154d8881bab3R1-R51) [\[2\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-c8a8b4e794809be028aae5493f89adb648c3d48f1c6a4acb029f00f3e5eefb0cR1-R5) [\[3\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-8e4dba7a0f0898e21951c1843788da2b31087d1d090088202b6f143febb7b56cR1) [\[4\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-df1e48c80b644aba1fe8d820705f42be86364fa7eea715b8715cdb9baecd824fR1)

* * *

**References:**  
[\[1\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-a3f1f6cf4e0895a8429cea07bf63bfe70dcaa0c5c89dd28ed034e37ad4998733R1-R348) [\[2\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-62f1d46426fd3f09630fb42f497190fd61dc9c6cdb1c7087dff9b5cd8a16ee72R1-R41) [\[3\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-446afc2efa10cf47c9bd3fb55f015c006cb72312c5e31fd0f369fa46d8876995R1-R254) [\[4\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-a2b2c4286e380d534e4bd7da686261e64b653e0578377c83bd8e154d8881bab3R1-R51) [\[5\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-c8a8b4e794809be028aae5493f89adb648c3d48f1c6a4acb029f00f3e5eefb0cR1-R5) [\[6\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-8e4dba7a0f0898e21951c1843788da2b31087d1d090088202b6f143febb7b56cR1) [\[7\]](https://github.com/frinfo702/ov-seg/pull/1/files#diff-df1e48c80b644aba1fe8d820705f42be86364fa7eea715b8715cdb9baecd824fR1)

[frinfo702](/frinfo702) added 2 commits [May 17, 2026 17:12](#commits-pushed-db52cb5)

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Replaced MaskFormer with SAM3](/frinfo702/ov-seg/pull/1/commits/db52cb50f63b9d286cdc0acc5d7e2d2dc3a54306 "Replaced MaskFormer with SAM3")`

  

  

`[db52cb5](/frinfo702/ov-seg/pull/1/commits/db52cb50f63b9d286cdc0acc5d7e2d2dc3a54306)`

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Add accelerate and transformers to dependencies](/frinfo702/ov-seg/pull/1/commits/beb15b61884f41d1eabb4dd2533602953f778700 "Add accelerate and transformers to dependencies")`

  

  

`[beb15b6](/frinfo702/ov-seg/pull/1/commits/beb15b61884f41d1eabb4dd2533602953f778700)`

[](/apps/copilot-pull-request-reviewer)[Copilot](/apps/copilot-pull-request-reviewer) AI review requested due to automatic review settings [May 17, 2026 08:17](#event-25622584245)

**Copilot** [started reviewing](https://github.com/frinfo702/ov-seg/sessions/684551cf-f4e8-402d-9a1a-677be2562e3b "View session") on behalf of [frinfo702](/frinfo702) [May 17, 2026 08:18](#event-25622594370) [View session](https://github.com/frinfo702/ov-seg/sessions/684551cf-f4e8-402d-9a1a-677be2562e3b)

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[refactor: Add type annotation](/frinfo702/ov-seg/pull/1/commits/2270d8fd29aacb75dbbfd08dea517c5c294df3aa "refactor: Add type annotation")`

  

  

`[2270d8f](/frinfo702/ov-seg/pull/1/commits/2270d8fd29aacb75dbbfd08dea517c5c294df3aa)`

[](/apps/copilot-pull-request-reviewer)

**[Copilot](/apps/copilot-pull-request-reviewer) AI** reviewed [May 17, 2026](#pullrequestreview-4305059940)

[View reviewed changes](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700)

Copy link

Copy Markdown

### 

**[Copilot](/apps/copilot-pull-request-reviewer) AI** left a comment

[](#pullrequestreview-4305059940)

There was a problem hiding this comment.

### Choose a reason for hiding this comment

The reason will be displayed to describe this comment to others. [Learn more](https://docs.github.com/articles/managing-disruptive-comments/#hiding-a-comment).

## Pull request overview

This PR introduces an OVSAM-Seg meta-architecture that uses SAM3 to generate mask proposals and then uses the existing CLIP adapter for open-vocabulary semantic segmentation. It also updates Python dependencies (Transformers/Accelerate) and adds an implementation plan + configuration for running the new architecture.

**Changes:**

-   Added `OVSAMSeg` meta-architecture plus `SAM3ProposalGenerator` (with multiple backends, including a subprocess worker).
-   Added a new `configs/ovsam_seg_swinB_vitL.yaml` and a detailed implementation-plan document for OVSAM-Seg.
-   Updated dependency/packaging files (requirements/pyproject/uv.lock) and added OpenCLIP packaging metadata files.

### Reviewed changes

Copilot reviewed 14 out of 19 changed files in this pull request and generated 9 comments.

Show a summary per file

File

Description

`uv.lock`

Adds Transformers/Accelerate and updates several locked deps; also modifies CUDA package dependency markers.

`requirements.txt`

Adds `transformers` and `accelerate`.

`pyrightconfig.json`

Adds Pyright configuration and excludes various directories.

`pyproject.toml`

Adds Transformers/Accelerate plus Ruff/Mypy/BasedPyright tool configs.

`ov_seg.egg-info/PKG-INFO`

Updates package metadata to include new dependencies.

`open_vocab_seg/modeling/sam3_worker.py`

Adds a subprocess worker used to run SAM3 in an alternate environment.

`open_vocab_seg/modeling/sam3_proposal.py`

Adds `SAM3ProposalGenerator` with transformers/sam3-package/subprocess backends.

`open_vocab_seg/modeling/ovsam_seg_model.py`

Adds `OVSAMSeg` Detectron2 meta-architecture integrating SAM3 proposals + CLIP classification.

`open_vocab_seg/modeling/mask_former_model.py`

Adds a second `MaskFormer` implementation under `modeling/`.

`open_clip_training/src/open_clip_torch.egg-info/*`

Adds OpenCLIP setuptools metadata artifacts (egg-info).

`doc/ovsam-seg-implementation-plan.md`

Adds a detailed design/implementation plan document for OVSAM-Seg.

`configs/ovsam_seg_swinB_vitL.yaml`

Adds config selecting `OVSAMSeg` and introduces `MODEL.SAM3.*` keys.

* * *

💡 [Add Copilot custom instructions](/frinfo702/ov-seg/new/main?filename=.github/instructions/*.instructions.md) for smarter, more guided reviews. [Learn how to get started](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot).

Comment thread [open\_vocab\_seg/modeling/ovsam\_seg\_model.py](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-a02bea6569d9dec2ada2be2dd2489635a712e6ab6641d5642f8589e84d7bbdb4) Outdated

Comment on lines +77 to +80

if len(class\_names) == 0:

log\_first\_n("No class names found for evaluation.", "WARNING")

h, w = batched\_inputs\[0\].get("height", 0), batched\_inputs\[0\].get("width", 0)

return \[{"sem\_seg": torch.zeros(1, h, w, device=self.device)}\]

Comment thread [open\_vocab\_seg/modeling/ovsam\_seg\_model.py](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-a02bea6569d9dec2ada2be2dd2489635a712e6ab6641d5642f8589e84d7bbdb4)

def device(self) -> torch.device:

return self.pixel\_mean.device # pyright: ignore\[reportReturnType\]

  

def forward(self, batched\_inputs: list\[dict\[str, Any\]\]) -> list\[dict\[str, torch.Tensor\]\]:

Comment thread [open\_vocab\_seg/modeling/sam3\_proposal.py](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-fa38dfcbdc4c4478fa85b2b905f17d35f5175125399c65c979a49b7cfe9a3ff8)

Comment on lines +241 to +243

PILImage = \_\_import\_\_("PIL.Image", fromlist=\["Image"\]).Image

PILImage.fromarray(img\_np, mode="RGB").save(image\_path)

  

Comment thread [open\_vocab\_seg/modeling/sam3\_proposal.py](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-fa38dfcbdc4c4478fa85b2b905f17d35f5175125399c65c979a49b7cfe9a3ff8)

Comment on lines +41 to +57

\# 1. transformers

if importlib.util.find\_spec("transformers"):

import transformers

from packaging.version import Version

  

if Version(transformers.\_\_version\_\_) >= Version("4.60.0"):

try:

from transformers import Sam3Model, Sam3Processor

  

self.model = Sam3Model.from\_pretrained(model\_name).eval()

self.processor = Sam3Processor.from\_pretrained(model\_name)

for p in self.model.parameters():

p.requires\_grad = False

return "transformers"

except ImportError:

pass

  

Comment thread [configs/ovsam\_seg\_swinB\_vitL.yaml](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-62f1d46426fd3f09630fb42f497190fd61dc9c6cdb1c7087dff9b5cd8a16ee72)

Comment on lines +17 to +22

SAM3:

ENABLED: True

MODEL\_NAME: "facebook/sam3"

MASK\_THRESHOLD: 0.5

MAX\_MASKS: 200

PROMPT\_SOURCE: "dataset"

Comment thread [configs/ovsam\_seg\_swinB\_vitL.yaml](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-62f1d46426fd3f09630fb42f497190fd61dc9c6cdb1c7087dff9b5cd8a16ee72)

Comment on lines +1 to +3

MODEL:

META\_ARCHITECTURE: "OVSAMSeg"

PIXEL\_MEAN: \[123.675, 116.280, 103.530\]

Comment thread [open\_vocab\_seg/modeling/mask\_former\_model.py](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-446afc2efa10cf47c9bd3fb55f015c006cb72312c5e31fd0f369fa46d8876995)

from ..modeling.matcher import HungarianMatcher

  

  

@META\_ARCH\_REGISTRY.register()

Comment thread [doc/ovsam-seg-implementation-plan.md](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-a3f1f6cf4e0895a8429cea07bf63bfe70dcaa0c5c89dd28ed034e37ad4998733)

Comment on lines +130 to +146

\### 新規ファイル

  

| ファイル | 内容 |

| ----------------------------------------- | --------------------------- |

| \`open\_vocab\_seg/modeling/sam3\_adapter.py\` | SAM3 モデルのラッパークラス |

| \`open\_vocab\_seg/ovsam\_seg\_model.py\` | OVSAMSeg モデルクラス |

  

\### 修正ファイル

  

| ファイル | 修正内容 |

| ------------------------------------- | ----------------------------------------- |

| \`open\_vocab\_seg/config.py\` | SAM3 用 config (\`MODEL.SAM3\`) 追加 |

| \`open\_vocab\_seg/\_\_init\_\_.py\` | \`OVSAMSeg\` を \`META\_ARCH\_REGISTRY\` に登録 |

| \`open\_vocab\_seg/utils/predictor.py\` | OVSAMSeg の predictor 追加 |

| \`demo.py\` | SAM3 config 読み込みの調整 |

| \`train\_net.py\` | eval-only 時のモデル選択 |

| \`pyproject.toml\` / \`requirements.txt\` | \`transformers\`, \`accelerate\` 追加 |

Comment thread [open\_clip\_training/src/open\_clip\_torch.egg-info/PKG-INFO](/frinfo702/ov-seg/pull/1/files/beb15b61884f41d1eabb4dd2533602953f778700#diff-252422b1e5e7bb2cc8b920c56321f624382a7b2f36425f72be5c4dfb3f03de7b)

Comment on lines +1 to +43

Metadata-Version: 2.4

Name: open\_clip\_torch

Version: 1.3.0

Summary: OpenCLIP

Home-page: https://github.com/mlfoundations/open\_clip

Author:

Author-email:

Keywords: CLIP pretrained

Classifier: Development Status :: 3 - Alpha

Classifier: Intended Audience :: Education

Classifier: Intended Audience :: Science/Research

Classifier: License :: OSI Approved :: Apache Software License

Classifier: Programming Language :: Python :: 3.7

Classifier: Programming Language :: Python :: 3.8

Classifier: Programming Language :: Python :: 3.9

Classifier: Programming Language :: Python :: 3.10

Classifier: Topic :: Scientific/Engineering

Classifier: Topic :: Scientific/Engineering :: Artificial Intelligence

Classifier: Topic :: Software Development

Classifier: Topic :: Software Development :: Libraries

Classifier: Topic :: Software Development :: Libraries :: Python Modules

Requires-Python: >=3.7

Description-Content-Type: text/markdown

License-File: LICENSE

Requires-Dist: torch>=1.9

Requires-Dist: torchvision

Requires-Dist: ftfy

Requires-Dist: regex

Requires-Dist: tqdm

Dynamic: classifier

Dynamic: description

Dynamic: description-content-type

Dynamic: home-page

Dynamic: keywords

Dynamic: license-file

Dynamic: requires-dist

Dynamic: requires-python

Dynamic: summary

  

\# OpenCLIP training for OVSeg

  

Note: This part is verbose and may contain many functions that are unused in OVSeg.

  

[![@linear-code](https://avatars.githubusercontent.com/in/1658531?s=80&v=4)](/apps/linear-code)

Copy link

Copy Markdown

### 

**[linear-code](/apps/linear-code) Bot** commented [May 17, 2026](#issuecomment-4469891150)

[ISSUE-1450](https://linear.app/uyuthropic/issue/ISSUE-1450)

[frinfo702](/frinfo702) added 6 commits [May 17, 2026 20:59](#commits-pushed-8574656)

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Revert "refactor: Add type annotation"](/frinfo702/ov-seg/pull/1/commits/8574656b1288c2a94131021bd0d8417199cc6813 "Revert \"refactor: Add type annotation\" This reverts commit 2270d8fd29aacb75dbbfd08dea517c5c294df3aa.")` …

  

  

`[8574656](/frinfo702/ov-seg/pull/1/commits/8574656b1288c2a94131021bd0d8417199cc6813)`

This reverts commit [2270d8f](https://github.com/frinfo702/ov-seg/commit/2270d8fd29aacb75dbbfd08dea517c5c294df3aa).

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Add basedpyright dev dependency and ignore rules](/frinfo702/ov-seg/pull/1/commits/b9feabea228926077da8f8c67f03bf0597e5bed9 "Add basedpyright dev dependency and ignore rules")`

  

  

`[b9feabe](/frinfo702/ov-seg/pull/1/commits/b9feabea228926077da8f8c67f03bf0597e5bed9)`

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Add basedpyright setting to CLIP](/frinfo702/ov-seg/pull/1/commits/4d1974187a95cc4eab45c22e0857d799947b0769 "Add basedpyright setting to CLIP")`

  

  

`[4d19741](/frinfo702/ov-seg/pull/1/commits/4d1974187a95cc4eab45c22e0857d799947b0769)`

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Integrate SAM3 support and add OVSAM3 demo](/frinfo702/ov-seg/pull/1/commits/96b49ee04a79a1f89cc7450d7e7611cb3ef18f31 "Integrate SAM3 support and add OVSAM3 demo - Add SAM3 config options (ENABLED, MODEL_NAME, MASK_THRESHOLD, MAX_MASKS, PROMPT_SOURCE) - Register OVSAMSeg architecture in open_vocab_seg modeling - Make SAM3 backend import robust and fix dtype handling for masks and scores - Add ovsam3-demo.py script for interactive demos - Improve CLI option handling in train_net.py by safely trimming odd-length opts - Update logging calls to safer signatures for missing class names or masks")` …

  

  

`[96b49ee](/frinfo702/ov-seg/pull/1/commits/96b49ee04a79a1f89cc7450d7e7611cb3ef18f31)`

\- Add SAM3 config options (ENABLED, MODEL\_NAME,
  MASK\_THRESHOLD, MAX\_MASKS, PROMPT\_SOURCE)
- Register OVSAMSeg architecture in open\_vocab\_seg
  modeling
- Make SAM3 backend import robust and fix dtype handling
  for masks and scores
- Add ovsam3-demo.py script for interactive demos
- Improve CLI option handling in train\_net.py by safely trimming
  odd-length opts
- Update logging calls to safer signatures for missing class
  names or masks

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[ignored resources/](/frinfo702/ov-seg/pull/1/commits/3fe2d634437c80cd5ee5924d88d3dc4321d6bcca "ignored resources/")`

  

  

`[3fe2d63](/frinfo702/ov-seg/pull/1/commits/3fe2d634437c80cd5ee5924d88d3dc4321d6bcca)`

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702)

`[Add OVSAM3 support with docs and eval script](/frinfo702/ov-seg/pull/1/commits/3e2d457c213b40f34c1a8f40af765f539419cbde "Add OVSAM3 support with docs and eval script - Improve OVSAMSeg with explicit imports and type hints - Use zeros instead of torch.zeros and add einsum for fusion - Handle empty SAM3 mask case gracefully and adjust logging - Add ovsam3/train_net.py as an evaluation script - Add doc/ovsam3-implementation-summary.md with overview")` …

  

  

`[3e2d457](/frinfo702/ov-seg/pull/1/commits/3e2d457c213b40f34c1a8f40af765f539419cbde)`

\- Improve OVSAMSeg with explicit imports and type hints
- Use zeros instead of torch.zeros and add einsum for fusion
- Handle empty SAM3 mask case gracefully and adjust logging
- Add ovsam3/train\_net.py as an evaluation script
- Add doc/ovsam3-implementation-summary.md with overview

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=40&v=4)](/frinfo702) [frinfo702](/frinfo702) merged commit [`32da390`](/frinfo702/ov-seg/commit/32da390bc03bf0a172b625a6a5cfa28b52e99b81) into main [May 18, 2026](https://github.com/frinfo702/ov-seg/pull/1#event-25640426198)

[Sign up for free](/join?source=comment-repo) **to join this conversation on GitHub**. Already have an account? [Sign in to comment](/login?return_to=https%3A%2F%2Fgithub.com%2Ffrinfo702%2Fov-seg%2Fpull%2F1)

### Labels

None yet

### 2 participants

[![@frinfo702](https://avatars.githubusercontent.com/u/121755762?s=52&v=4)](/frinfo702)[](/apps/copilot-pull-request-reviewer)

Add this suggestion to a batch that can be applied as a single commit.This suggestion is invalid because no changes were made to the code.Suggestions cannot be applied while the pull request is closed.Suggestions cannot be applied while viewing a subset of changes.Only one suggestion per line can be applied in a batch.Add this suggestion to a batch that can be applied as a single commit.Applying suggestions on deleted lines is not supported.You must change the existing code in this line in order to create a valid suggestion.Outdated suggestions cannot be applied.This suggestion has been applied or marked resolved.Suggestions cannot be applied from pending reviews.Suggestions cannot be applied on multi-line comments.Suggestions cannot be applied while the pull request is queued to merge.Suggestion cannot be applied right now. Please check back later.