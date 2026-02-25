#Requires AutoHotkey v2.0

; === 파일 경로 설정 ===

life_low_black  := A_ScriptDir "\hpblacklow.png"
util_low_img    := A_ScriptDir "\quick2.png" 
util_high_img   := A_ScriptDir "\quick1.png"
bv_img          := A_ScriptDir "\bv.png"
pg_img          := A_ScriptDir "\pg.png"
tinc_off        := A_ScriptDir "\off.png"
tinc_on         := A_ScriptDir "\on.png"
tinc_sleep      := A_ScriptDir "\sleep.png"

; === 상태 관리 변수 ===
isRunning := false 

; === 핫키 정의 ===
F2::StartMacro() ; F2 키로 매크로 시작
F3::StopMacro()  ; F3 키로 매크로 정지
^!x::ExitApp      ; Ctrl + Alt + X 로 프로그램 종료

; === 매크로 시작 함수 ===
StartMacro() {
    global isRunning
    if (!isRunning) {
        isRunning := true
        SetTimer LifeCheck, 100
        SetTimer UtilityCheck, 100
        ; SetTimer bvCheck, 100
        ; SetTimer pgCheck, 100
        SetTimer tincCheck, 100
        TrayTip("매크로", "▶ 실행 중... (F3으로 정지)", 1)
    }
}

; === 매크로 정지 함수 ===
StopMacro() {
    global isRunning
    if (isRunning) {
        isRunning := false
        SetTimer LifeCheck, 0
        SetTimer UtilityCheck, 0
        ; SetTimer bvCheck, 0
        ; SetTimer pgCheck, 0
        SetTimer tincCheck, 0
        TrayTip("매크로", "⏸ 일시 정지됨 (F2로 시작)", 1)
    }
}

; === 기능 1: 생명력 플라스크 조절 ===
LifeCheck() {
    global life_low_black, isRunning
    static isWaiting := false 

    if (isWaiting)
        return

    if ImageSearch(&foundX, &foundY, 90, 940, 135, 955, "*180 " life_low_black) {
        isWaiting := true
        SetTimer LifeCheck, 0 

        Send("{1}")
        Sleep(Random(50, 150)) ; 키 입력 사이 짧은 간격

        Sleep(Random(4000, 4250)) 

        isWaiting := false
        if (isRunning) 
            SetTimer LifeCheck, 100 
    }
}

; === 기능 2: 유틸 플라스크 조절 (2,3,4번 연타) ===
UtilityCheck() {
    global util_low_img, isRunning
    static isWaiting := false

    if (isWaiting)
        return

    if ImageSearch(&foundX, &foundY, 350, 970, 500, 1080, "*115 " util_low_img) {
        isWaiting := true
        SetTimer UtilityCheck, 0

        ; 플라스크 연타
        Loop 4 {
            Send("{" (A_Index + 1) "}") ; 2, 3, 4, 5번 순차 입력

            Sleep(Random(50, 150))
        }
        ; A_Index란?
        ; 오토핫키에서 Loop가 실행될 때, 현재 몇 번째 반복 중인지를 저장하는 변수입니다.
        ; 첫 번째 반복 시: A_Index는 1
        ; 두 번째 반복 시: A_Index는 2
        ; 세 번째 반복 시: A_Index는 3
        Sleep(Random(3850, 4100)) ; 유틸 플라스크 지속 시간 대기

        isWaiting := false
        if (isRunning)
            SetTimer UtilityCheck, 100
    }
}

; ; === 기능 3: 블레이드 볼텍스(BV) 자동화 ===
; ; 촉발 보조 스킬로, 화면 우측 하단에 아이콘이 나타납니다. 해당 부분의 숫자 4를 서칭합니다.
; bvCheck() {
;     global bv_img, isRunning
;     static isWaiting := false

;     if (isWaiting)
;         return

;     if ImageSearch(&foundX, &foundY, 1635, 1010, 1690, 1080, "*150 " bv_img) {
;         isWaiting := true
;         SetTimer bvCheck, 0

;         Send("{T}")
;         Sleep(Random(2500, 2800)) ; BV 유지 보수 간격

;         isWaiting := false
;         if (isRunning)
;             SetTimer bvCheck, 100
;     }
; }

; ; === 기능 4: 독성 운반자(PG) 자동화 ===
; ; on상태 off 상태가 스킬 아이콘이 다릅니다, 화면 우측 하단에 아이콘이 나타납니다. 해당 부분의 이미지를 서칭합니다.
; pgCheck() {
;     global pg_img, isRunning
;     static isWaiting := false

;     if (isWaiting)
;         return

;     if ImageSearch(&foundX, &foundY, 1575, 1010, 1635, 1080, "*200 " pg_img) {
;         isWaiting := true
;         SetTimer pgCheck, 0

;         Send("{R}")
;         Sleep(Random(100, 200)) ; 짧은 입력 딜레이

;         isWaiting := false
;         if (isRunning)
;             SetTimer pgCheck, 100
;     }
; }

; === 기능 5: 팅크(Tincture) 조절 ===
tincCheck() {
    global tinc_on, tinc_off, tinc_sleep, isRunning
    static isWaiting := false 
    
    if (isWaiting)
        return

    ; 1. OFF 상태일 때 켬
    if ImageSearch(&foundX, &foundY, 490, 1000, 535, 1075, "*180 " tinc_off) {
        isWaiting := true
        SetTimer tincCheck, 0
        
        Send("{5}")
        Sleep(Random(300, 500)) 
        
        isWaiting := false
        if (isRunning)
            SetTimer tincCheck, 100
    }
    ; 2. SLEEP(충전중) 상태일 때 대기
    else if ImageSearch(&foundX, &foundY, 490, 1000, 535, 1075, "*180 " tinc_sleep) {
        isWaiting := true
        SetTimer tincCheck, 0
        
        Sleep(4000) ; 팅크 쿨타임 대기
        
        isWaiting := false
        if (isRunning)
            SetTimer tincCheck, 100
    }
}