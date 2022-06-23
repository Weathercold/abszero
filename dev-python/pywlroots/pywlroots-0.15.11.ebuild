# Copyright 2021 Gentoo Authors, Sean Vig and Weathercold
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A Python binding to the wlroots library using cffi"
HOMEPAGE="https://github.com/flacjacket/pywlroots"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xwayland"

DEPEND="xwayland? ( x11-base/xwayland )"

RDEPEND="
    ${DEPEND}
    $(python_gen_cond_dep '>=dev-python/cffi-1.12.0:=[${PYTHON_USEDEP}]' 'python*')
    $(python_gen_cond_dep 'dev-python/dataclasses[${PYTHON_USEDEP}]' python3_6)
    >=dev-python/pywayland-0.1.1[${PYTHON_USEDEP}]
    >=dev-python/xkbcommon-0.2[${PYTHON_USEDEP}]
    >=gui-libs/wlroots-0.15.0:=
    <gui-libs/wlroots-0.16.0:=
"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=("${FILESDIR}"/${PF}-no_version_check.patch)