#!/bin/bash

# -----------------------------
# U-15 Security Audit Script
# 불필요한 계정/그룹 소유 파일 점검
# -----------------------------

clear

printf "\n#########################################\n"
printf "#        U-15 보안 점검 시작           #\n"
printf "#########################################\n\n"

# 잠시 대기
sleep 1

# 결과 파일 생성
RESULT_LOG="/tmp/u15_result_$$.log"

# 검사 실행
find / -xdev -type f \( -nouser -o -nogroup \) 2>/dev/null > "$RESULT_LOG"

# 결과 수집
FILE_TOTAL=$(grep -c "" "$RESULT_LOG")

# 상태 출력
printf "[INFO] 검사 완료\n"
printf "[INFO] 소유자/그룹 이상 파일 개수 : %d\n" "$FILE_TOTAL"
printf "-----------------------------------------\n"

# 판정
case $FILE_TOTAL in
    0)
        printf "[양호] U-15 기준 충족\n"
        printf "모든 파일이 정상적인 사용자 및 그룹 정보를 가지고 있습니다.\n"
        ;;
    *)
        printf "[취약] U-15 기준 미충족\n"
        printf "소유자 또는 그룹 정보가 없는 파일이 발견되었습니다.\n\n"
        printf "[세부 경로]\n"
        nl -w2 -s'. ' "$RESULT_LOG"
        ;;
esac

# 마무리
rm -f "$RESULT_LOG"

printf "\n#########################################\n"
printf "#        U-15 보안 점검 종료           #\n"
printf "#########################################\n"