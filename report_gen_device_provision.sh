#!/usr/bin/bash
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################################
# @Author  : weilinfox
# @email   : caiweilin@iscas.ac.cn
# @Date    : 2024-04-16 16:52:20
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc    : Generate device provision test report
###################################################

OET_PATH=$(
    cd "$(dirname "$0")" || exit 1
    pwd
)
RUN_PATH=$(pwd)

source ${OET_PATH}/testcases/cli-test/ruyi/common/common_lib.sh

tmpl_dir=${OET_PATH}/report_gen_tmpl/device_provision
report_name="RUYI_包管理_device_provision_测试结果"
report_dir=${OET_PATH}/ruyi_device_report

mkdir $report_dir
[ ! -f $tmpl_dir/26test_log.md ] && {
	echo 26test_log.md not appears
	exit -1
}

export_ruyi_link

cat "$tmpl_dir"/*.md > $report_dir/my

sed -i "s/{{ruyi_arch}}/$arch/g" $report_dir/my
sed -i "s/{{ruyi_version}}/$version/g" $report_dir/my
sed -i "s|{{ruyi_link}}|$ruyi_link|g" $report_dir/my

# format test logs name
for f in $(find "${OET_PATH}"/logs -type f); do
	mv "$f" "$(echo "$f" | sed "s/:/_/g")"
done

mv -v "${OET_PATH}"/logs/* $report_dir/
mv -v $report_dir/my $report_dir/$report_name.md

