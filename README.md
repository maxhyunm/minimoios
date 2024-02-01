# Minimo iOS🗒️

## 소개
> 간단한 글과 사진을 올리면 타임라인 형식으로 보여주는 앱입니다.
> 구글과 카카오로 로그인이 연동되고, 프로필사진과 닉네임을 변경할 수 있습니다.
> 
> **프로젝트 기간**
> 1차: 2024.01.26 ~ 

## 목차
1. [👩‍💻 팀원 소개](#1.)
2. [📅 타임 라인](#2.)
3. [🛠️ 활용 기술](#3.)
4. [📱 실행 화면](#4.)
5. [📌 핵심 경험](#5.)

<a id="1."></a>
## 👩‍💻 팀원 소개
|<Img src="https://hackmd.io/_uploads/rk62zRiun.png" width="200">|
|:-:|
|[**maxhyunm**](https://github.com/maxhyunm)<br>(minhmin219@gmail.com)|

<a id="2."></a>
## 📅 타임 라인
|날짜|내용|
|:--:|--|
|2023.01.26| Kakao OAuth 로그인 연동 |
|2023.01.27| Google OAuth 로그인 연동 |
|2023.01.28| OAuthType, LoginViewModel 타입 생성<br>테스트 데이터 생성(json) |
|2023.01.29| Firebase 연결 및 FirebaseManager 생성<br>Users, Contents DTO 생성<br>LoginViewModel → AuthModel 변환<br> |
|2023.01.30| Timeline 구현(MinimoList, MinimoRow)<br>메모작성 구현(WriteView)<br>메모삭제 구현<br>Auth와 User 모델 분리<br>프로필 수정 구현(EditProfileView) |
|2023.01.31| PhotosUI를 활용한 이미지 업로드 기능 추가<br>이미지 팝업창 추가<br>TabView 추가하여 Profile과 Timeline 구분 |
|2023.02.01| README 1차 작성 |

<a id="3."></a>
## 🛠️ 활용 기술
|Framework|Architecture|Concurrency|DB|Dependency Manager|
|:-:|:-:|:-:|:-:|:-:|
|SwiftUI|MVVM|Combine|Firebase|SPM|

<a id="4."></a>
## 📱 실행 화면
| 로그인 화면 | 카카오 로그인 | 구글 로그인 |
|:-:|:-:|:-:|
|<img src="https://hackmd.io/_uploads/Hk5HYKO9p.gif" width="250">|<img src="https://hackmd.io/_uploads/H14BYtO9T.gif" width="250">|<img src="https://hackmd.io/_uploads/BJUStY_5T.gif" width="250">|


| 타임라인 탭 | 프로필 탭 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/SkJWqKO9a.gif" width="250">|<img src="https://hackmd.io/_uploads/r1-WqFd96.gif" width="250">|


| 메모 쓰기 | 사진 선택 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/Hk185K_q6.gif" width="250">|<img src="https://hackmd.io/_uploads/Hkz89K_ca.gif" width="250">|


| 프로필 수정 진입 | 프로필 수정 진행 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/HJPxcKu5a.gif" width="250">|<img src="https://hackmd.io/_uploads/Sydx5K_cp.gif" width="250">|

<a id="5."></a>
## 📌 핵심 경험
#### 🌟 SwiftUI + Combine + MVVM 활용
SwiftUI와 Combine을 함께 활용하여 비동기 기능 및 데이터바인딩을 구현하였습니다.

#### 🌟 Firebase 활용
서버나 CoreData 대신 Firebase를 활용하여 유저 정보, 메모 데이터 및 이미지 파일 CRUD를 구현하였습니다.

#### 🌟 PhotosUI 활용
여러 장의 이미지를 선택할 수 있도록 하기 위하여 PhotosPicker를 활용하였습니다.

#### 🌟 AsyncImage 활용
비동기로 이미지를 띄우기 위하여 AsyncImage를 활용하였습니다.
