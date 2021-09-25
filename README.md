# What's this

Check for [Smithay/input.rs/issues/31](https://github.com/Smithay/input.rs/issues/31)

## Usage

with libinput v1.19.0

```
docker run --rm --device /dev/input --mount type=bind,source=/run/udev,target=/run/udev,readonly ghcr.io/yskszk63/inputrs-with-gesture-hold:1.19.0 /app
```

with [https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/697](https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/697)

```
docker run --rm --device /dev/input --mount type=bind,source=/run/udev,target=/run/udev,readonly ghcr.io/yskszk63/inputrs-with-gesture-hold:mr697 /app
```
