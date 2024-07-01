pkgname=mkinitcpio-encryptssh
pkgver=master
pkgrel=1
pkgdesc='Alternative encryptssh hook that also works with plymouth'
arch=('any')
url='https://github.com/jacklul/mkinitcpio-encryptssh'
license=('GPL-2.0-or-later AND BSD-3-Clause')
depends=('cryptsetup')
makedepends=('git' 'coreutils')
conflicts=('mkinitcpio-utils')
optdepends=(
    'mkinitcpio-dropbear: Use dropbear for remote unlock'
    'mkinitcpio-tinyssh: Use tinyssh for remote unlock'
)
source=(hook.patch install.patch shell.sh)
md5sums=(SKIP SKIP SKIP)
[ -f pacman.hook ] && source+=(pacman.hook) && md5sums+=(SKIP)

pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
}

package() {
    _filesdir="$(realpath .)"
    _repository='https://gitlab.archlinux.org/archlinux/mkinitcpio/mkinitcpio.git'
    _latest_tag="$(git ls-remote --tags "$_repository" | grep -E "tags/v.*[0-9]$" | tail -n 1 | sed 's/.*refs\/tags\///')"

    if [ ! -d "$srcdir/mkinitcpio" ]; then
        git clone -c advice.detachedHead=false --depth 1 --branch "$_latest_tag" "$_repository" "$srcdir/mkinitcpio"
    else
        git -C "$srcdir/mkinitcpio" clean -fd
        git -C "$srcdir/mkinitcpio" reset --hard HEAD
        git -C "$srcdir/mkinitcpio" fetch --depth 1
        git -C "$srcdir/mkinitcpio" checkout "$_latest_tag"
    fi

    sha256sum < "$srcdir/mkinitcpio/hooks/encrypt" | awk '{print $1}' > "$srcdir/hook.sha256"
    sha256sum < "$srcdir/mkinitcpio/install/encrypt" | awk '{print $1}' > "$srcdir/install.sha256"

    git -C "$srcdir/mkinitcpio" apply "$_filesdir/hook.patch"
    git -C "$srcdir/mkinitcpio" apply "$_filesdir/install.patch"

    install -Dm644 "$srcdir/mkinitcpio/hooks/encrypt"    "$pkgdir/usr/lib/initcpio/hooks/encryptssh"
    install -Dm644 "$srcdir/mkinitcpio/install/encrypt"  "$pkgdir/usr/lib/initcpio/install/encryptssh"
    install -Dm755 "$_filesdir/shell.sh"                  "$pkgdir/usr/share/$pkgname/cryptsetup_shell.sh"
    install -Dm644 "$srcdir/hook.sha256"                 "$pkgdir/usr/share/$pkgname/hook.sha256"
    install -Dm644 "$srcdir/install.sha256"              "$pkgdir/usr/share/$pkgname/install.sha256"

    [ -f "$_filesdir/pacman.hook" ] && install -Dm644 "$_filesdir/pacman.hook"  "$pkgdir/usr/share/libalpm/hooks/30-encryptssh.hook"
}
