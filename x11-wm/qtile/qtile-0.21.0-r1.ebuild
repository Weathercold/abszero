# Copyright 1999-2022 Gentoo Authors, Weathercold
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 virtualx

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="http://qtile.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="X wayland dbus"
REQUIRED_USE="?? ( X wayland )"

RDEPEND="
	>=dev-python/cairocffi-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	media-sound/pulseaudio
	x11-libs/cairo[X,xcb(+)]
	x11-libs/pango
	x11-libs/libnotify[introspection]
	
	X? (
		>=dev-python/xcffib-0.10.1[${PYTHON_USEDEP}]
		x11-base/xorg-server
	)
	
	wayland? (
		dev-python/pywayland[${PYTHON_USEDEP}]
		dev-python/pywlroots[${PYTHON_USEDEP}]
		dev-python/xkbcommon[${PYTHON_USEDEP}]
		gui-libs/wlroots
	)
	
	dbus? ( dev-python/dbus-next[${PYTHON_USEDEP}] )"
BDEPEND="
	test? (
		media-gfx/imagemagick[X]
		x11-base/xorg-server[xephyr]
	)"

EPYTEST_DESELECT=(
	# Can't find built qtile like migrate
	test/test_qtile_cmd.py::test_qtile_cmd
	test/test_qtile_cmd.py::test_display_kb
)

EPYTEST_IGNORE=(
	# Tries to find binary and fails; not worth running anyway?
	test/test_migrate.py
)

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# Force usage of built module
	rm -rf "${S}"/libqtile || die

	epytest || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	distutils-r1_python_install_all

	if use X; then
		insinto /usr/share/xsessions
		doins resources/qtile.desktop
		
		exeinto /etc/X11/Sessions
		newexe "${FILESDIR}"/${PN}-session-r1 ${PN}
	fi

	if use wayland; then
		insinto /usr/share/wayland-sessions
		doins "${FILESDIR}"/qtile.desktop
	fi
}
