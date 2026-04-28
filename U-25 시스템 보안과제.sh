#!/bin/bash

# ----------------------------------------
# U-25 Security Inspection Script
# World Writable 일반 파일 점검
# ----------------------------------------

clear

printf "\n#########################################\n"
printf "#        U-25 보안 점검 시작           #\n"
printf "#########################################\n\n"

sleep 1

# 임시 저장 파일
REPORT_FILE="/tmp/u25_scan_$$.txt"

# Others(기타 사용자)에게 쓰기 권한이 있는 일반 파일 검색
find / -xdev -type f -perm -0002 2>/dev/null > "$REPORT_FILE"

# 발견 개수
VULN_COUNT=$(awk 'END{print NR}' "$REPORT_FILE")

printf "[INFO] 검사 완료\n"
printf "[INFO] World Writable 파일 수 : %d\n" "$VULN_COUNT"
printf "-----------------------------------------\n"

# 결과 판정
if [ "$VULN_COUNT" -eq 0 ]; then
    printf "[양호] U-25 기준 충족\n"
    printf "모든 일반 파일이 안전한 권한 상태입니다.\n"
else
    printf "[취약] U-25 기준 미충족\n"
    printf "모든 사용자가 쓰기 가능한 파일이 존재합니다.\n\n"
    printf "[취약 파일 상세 정보]\n"

    while IFS= read -r target; do
        [ -e "$target" ] && stat -c "권한: %A | 소유자: %U | 그룹: %G | 경로: %n" "$target"
    done < "$REPORT_FILE"
fi

# 임시 파일 정리
rm -f "$REPORT_FILE"

printf "\n#########################################\n"
printf "#        U-25 보안 점검 종료           #\n"
printf "#########################################\n"