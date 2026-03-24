![ ](imgs/ic_deepMind_h.png)</br>
![ ](imgs/mockup.PNG)</br>
# DeepMind</br>
### Check your psychological status with ML, based on YOLOv8<br>
ⓒ 2023. Changjin Ha, [Yujee-Chang](https://github.com/yujeecatherine). All Rights Reserved.<br><br>

## 🚀 Tech Stack

### Client (iOS)

<img src="https://img.shields.io/badge/Swift-df5d43?style=flat-square&logo=Swift&logoColor=white"/></a>
<img src="https://img.shields.io/badge/SwiftUI-df5d43?style=flat-square&logo=Swift&logoColor=white"/></a>

### Backend (BaaS & Serverless)

- Firebase Firestore: Realtime chat and sync inspection/health data
- Firebase Cloud Functions: Process backend business logic to reduce client burden
- Firebase Cloud Messaging: Send push notifications to target user when new consultation or chat is updated

### AI

- PyTorch: To train and evaluate YOLO models
- CoreML: Maximize performance for On-Device AI

### External API

- Naver Maps API (Render location based markers)


## 🏗️ Architecture

```mermaid
graph TD
    %% AI Model pipeline
    subgraph AIPipeline [🧠 AI Pipeline]
        PyTorch[PyTorch YOLO]
        Export[CoreMLTools / Export]
        PyTorch -->|Train & Eval| Export
    end

    %% Client
    subgraph Client [📱 iOS App]
        UI[SwiftUI]
        CoreML[CoreML / Vision]
        State[State Management]

        Export -.->|Deploy Model| CoreML
        CoreML <-->|On-Device Inference| State
        UI <--> State
    end

    %% Backend & Infra
    subgraph Serverless [☁️ Firebase BaaS]
        Auth[Firebase Auth]
        DB[Firebase Firestore]
        Storage[Firebase Storage]
        Functions[Firebase Cloud Functions]
        FCM[Firebase Cloud Messaging]
    end

    %% External API
    subgraph External [External APIs]
        Map[Naver Maps API]
    end

    %% Data flow
    State <--> Auth
    State <--> DB
    State <--> Storage
    State --> Map

    %% Push notifications and BE logic flow
    DB -->|Event Trigger| Functions
    Functions -->|Send Push Request| FCM
    FCM -.->|Push Notification| UI
```

## 🧱 If I were to rebuild it in 2026

| Layer | Original | 2026 Pick | Reason |
|---|---|---|---|
| Package Management | CocoaPods + SPM | SPM Only | Official support of NMapsMap |
| Encrypt | CryptoSwift (`main` branch) | Apple CryptoKit | First-party, Persistence to Secure Enclave, Remove branch pin |
| CoreML Execution | Sync for every call new instance | Cache with `actor` + `MLModelConfiguration(.all)` | Accelerate ANE, Thread safety, Reusable |
| VNCoreMLRequest | Sync `handler.perform([request])` | `async let` + `VNImageRequestHandler.perform` | Async, No UI blocking |
| PDF generation | CoreGraphics | SwiftUI View -> `UIHostingController` -> PDF renderer | 1/5 code, preview available |
| Authorization session | UserDefaults (Encrypt credentials) | Use Firebase Auth's own session | Safety |
| Authorization | Callback based | `async throws` | Delete nested callbacks, clearable error handling |

## ✨ Core Features</br>
<details>
<summary>Show Contents</summary>

#### Home</br>
> Check your latest inspection results, emotion statistics, health data and Latest informations at a glance.</br>

![ ](imgs/home_1.PNG)</br>

#### Daily Emotion</br>
> Once a day, record your emotion.</br>

![ ](imgs/dailyEmotion_1.PNG)</br>

#### Inspection</br>
> Draw House, Tree, Person with your Apple Pencil, or any inputs.</br>

![ ](imgs/inspection_1.PNG) ![ ](imgs/inspection_2.PNG) ![ ](imgs/inspection_3.PNG) ![ ](imgs/inspection_4.PNG)</br>

> Get image detection, powered by YOLOv8x.</br>

![ ](imgs/inspection_5.PNG)</br>

> Check Essential Information for your image.</br>

![ ](imgs/inspection_6.PNG)</br>

> Check your inspection results in the blink of an eye </br>

![ ](imgs/inspection_8.PNG)</br>

> Share your inspection data as PDF. </br>

![ ](imgs/inspection_7.PNG)</br>

> Share your inspection data to Community. </br>

![ ](imgs/inspection_9.PNG)</br>

#### Consulting</br>
> The easiest way to contact a professional. </br>

![ ](imgs/consulting_1.PNG)</br>

> Book a consultation with just one touch. </br>

![ ](imgs/consulting_2.PNG)</br>

> Consult in a comfortable way between chat and door-to-door consultation. </br>

![ ](imgs/consulting_3.PNG) ![ ](imgs/consulting_4.PNG) </br>

> Is the consultation over? Evaluate your experts and share them with others. </br>

![ ](imgs/consulting_5.PNG) </br>

#### Pros</br>
The simplest consultation solution for professionals. </br>
> Check your consultation reservation status on one screen. </br>

![ ](imgs/pro_1.PNG) </br>

> Of course, it also provides the most comfortable means to communicate with your customers. </br>

![ ](imgs/pro_2.PNG) </br>

> Get customer information the easiest way. </br>

![ ](imgs/pro_3.PNG) ![ ](imgs/pro_4.PNG) </br>

> Is the consultation over? Evaluate your customers and share them with others. </br>

![ ](imgs/pro_5.PNG)

#### Community</br>
> An easy way to communicate with people around the world </br>

![ ](imgs/community_1.PNG) </br>

> Talk to people through posts and comments. </br>

![ ](imgs/community_2.PNG) </br>

#### Grow-up Diary</br>
> Once a day, record your day with emotions.</br>

![ ](imgs/dailyDiary_1.PNG)</br>

> Record your day with images, markups, and text. </br>

![ ](imgs/dailyDiary_2.PNG)</br>

#### Statistics</br>
> Check your inspection results, emotion statistics history by date, with a chart.</br>

![ ](imgs/statistics_1.PNG) ![ ](imgs/statistics_2.PNG) ![ ](imgs/statistics_3.PNG)</br>

#### and so much more.</br>
> Change your information, delete your data on server, change your sensitive info, sign out, and secession </br>

![ ](imgs/more.PNG) </br>

## Compatibility</br>
> DeepMind is compatible with these devices. </br>
### iPhone</br>

> iPhone 15 Pro Max </br>
 iPhone 15 Pro </br>
 iPhone 15 Plus </br>
 iPhone 15 </br>
 iPhone 14 Pro Max </br>
 iPhone 14 Pro </br>
 iPhone 14 Plus </br>
 iPhone 14 </br>
 iPhone 13 Pro Max </br>
 iPhone 13 Pro </br>
 iPhone 13 </br>
 iPhone 13 mini </br>
 iPhone 12 Pro Max </br>
 iPhone 12 Pro </br>
 iPhone 12 </br>
 iPhone 12 mini </br>
 iPhone 11 Pro Max </br>
 iPhone 11 Pro </br>
 iPhone 11 </br>
 iPhone Xs Max </br>
 iPhone Xs </br>
 iPhone X<sub>R</sub> </br>
 iPhone SE (3rd-Generation) </br>
 iPhone SE (2nd-Generation) </br>

### iPad</br>

> iPad Pro 12.9 (6th-Generation) </br>
 iPad Pro 11 (4th-Generation) </br>
 iPad Pro 12.9 (5th-Generation) </br>
 iPad Pro 11 (3rd-Generation) </br>
 iPad Pro 12.9 (4th-Generation) </br>
 iPad Pro 11 (2nd-Generation) </br>
 iPad Pro 12.9 (3rd-Generation) </br>
 iPad Pro 11 (1st-Generation) </br>
 iPad Pro 12.9 (2nd-Generation) </br>
 iPad Pro 10.5 </br>
 iPad Air (5th-Generation) </br>
 iPad Air (4th-Generation) </br>
 iPad Air (3rd-Generation) </br>
 iPad mini (6th-Generation) </br>
 iPad mini (5th-Generation) </br>
 iPad (10th-Generation) </br>
 iPad (9th-Generation) </br>

 * Required iOS/iPadOS 17.0 or up. </br>
 * 1GB or higher storage required for install application.

</details>
