# Constraints — brain-kit

| Constraint | Notes |
|------------|-------|
| Test brainctl fixes with `bash /path/to/brainctl`, not the system copy | The system brainctl at `/etc/profiles/per-user/eduardo/bin/brainctl` is Nix-managed and lags behind the source in `brain-kit/brainctl` until a rebuild. Always test against the source directly. |
