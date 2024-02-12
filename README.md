# Minimo iOS🗒️

## 소개
> 간단한 메모와 사진을 올리면 타임라인 형식으로 보여주는 앱입니다.<br/>
> 구글과 카카오로 로그인이 연동되고, 프로필사진과 닉네임을 변경할 수 있습니다.<br/>
> 다른 사용자의 계정을 팔로우하거나 메모에 박수를 칠 수 있습니다.<br/>
> 사용자 또는 메모를 검색할 수 있습니다.<br/>
><br/>
> **최소사양**<br/>
> iOS 16 ~<br/>
> <br/>
> **프로젝트 기간**<br/>
> 1차: 2024.01.26 ~ <br/>

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
|2023.02.02| Home/Profile/Write 뷰모델 분리<br> fetchTrigger 생성 |
|2023.02.06| Follow 모델 추가<br>팔로우 시스템 구현<br>프로필 오류 수정 |
|2023.02.07| EnvironmentObject를 ObservedObject로 일부 변경<br>일부 Combine 코드 Async/Await으로 변경<br>네비게이션 오류 수정<br>탭뷰 커스텀하여 리팩토링 |
|2023.02.08| 유저/게시글 검색 기능 구현<br>프로필 내 검색 기능 구현<br>헤더 디자인 변경|
|2023.02.09| 기존 Combine 코드 전체 Async/Await으로 변경<br> 박수 기능 구현<br> 바이오 기능 구현<br>다크모드 색상 추가 |
|2023.02.10| 프로필에서 내비게이션바 삭제 |
|2023.02.12| README 2차 작성 |


<a id="3."></a>
## 🛠️ 활용 기술
|Framework|Architecture|Concurrency|DB|Dependency Manager|
|:-:|:-:|:-:|:-:|:-:|
|SwiftUI|MVVM|Swift Concurrency|Firebase|SPM|

<a id="4."></a>
## 📱 실행 화면
| 카카오 로그인 | 구글 로그인 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/SkCSSQDj6.gif" width="250">|<img src="https://hackmd.io/_uploads/ByepBrmPip.gif" width="250">|


| 타임라인 탭 | 사진 보기 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/HJArB7woT.gif" width="250">|<img src="https://hackmd.io/_uploads/S16rHXvs6.gif" width="250">|

| 메모 쓰기 | 메모 삭제 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/By2HBQwop.gif" width="250">|<img src="https://hackmd.io/_uploads/Hk-0BHmPsT.gif" width="250">|

| 프로필 탭 | 프로필 수정 | 프로필 내 검색 |
|:-:|:-:|:-:|
|<img src="https://hackmd.io/_uploads/BylpBHXPoT.gif" width="250">|<img src="https://hackmd.io/_uploads/HyCHB7Dop.gif" width="250">|<img src="https://hackmd.io/_uploads/BJpSHmwoa.gif" width="250">|

| 팔로우 | 언팔로우 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/H1eASBQDsa.gif" width="250">|<img src="https://hackmd.io/_uploads/rJABr7Pj6.gif" width="250">|

| 유저 검색 | 메모 검색 & 박수치기 |
|:-:|:-:|
|<img src="https://hackmd.io/_uploads/ryprH7DjT.gif" width="250">|<img src="https://hackmd.io/_uploads/HyoHHQDia.gif" width="250">|


<a id="5."></a>
## 📌 핵심 경험
#### 🌟 SwiftUI + Swift Concurrency + MVVM 활용
SwiftUI와 Async/Await을 함께 활용하여 비동기 기능 및 데이터바인딩을 구현하였습니다.

#### 🌟 Firebase 활용
서버나 CoreData 대신 Firebase를 활용하여 유저 정보, 메모 데이터 및 이미지 파일 CRUD를 구현하였습니다.

#### 🌟 PhotosUI 활용
여러 장의 이미지를 선택할 수 있도록 하기 위하여 PhotosPicker를 활용하였습니다.

#### 🌟 AsyncImage 활용
비동기로 이미지를 띄우기 위하여 AsyncImage를 활용하였습니다.

#### 🌟 ColorScheme 활용
ColorScheme Environment값을 활용하여 다크/라이트모드를 지원하도록 하였습니다.
