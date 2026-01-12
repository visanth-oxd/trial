# CI/CD Pipeline Fixes

## Issues Fixed

### 1. Terraform Validate Modules Error
**Error:** `Too many command line arguments. Did you mean to use -chdir?`

**Root Cause:** Newer versions of Terraform (1.0+) require using `-chdir` flag instead of passing the directory as a command-line argument.

**Fix Applied:**
```yaml
# Before (incorrect):
terraform init -backend=false -input=false $module
terraform validate -no-color $module

# After (correct):
terraform -chdir="$module" init -backend=false -input=false
terraform -chdir="$module" validate -no-color
```

### 2. tflint Error
**Error:** `Command line arguments support was dropped in v0.47. Use --chdir or --filter instead.`

**Root Cause:** tflint v0.47+ dropped support for passing directories as command-line arguments. Must use `--chdir` flag.

**Fix Applied:**
```yaml
# Before (incorrect):
tflint --init $module
tflint $module

# After (correct):
tflint --init --chdir="$module"
tflint --chdir="$module"
```

## Files Modified

1. **`.github/workflows/terraform-validate.yml`**
   - Fixed Terraform validate modules step (lines 65-66)
   - Fixed tflint on modules step (lines 91-92)
   - Fixed tflint on environments step (lines 99-100)

## Verification

The pipeline should now:
- ✅ Successfully validate all Terraform modules
- ✅ Successfully run tflint on all modules and environments
- ✅ Show green checkmarks (✅) when validation passes

## Testing

To test locally (if you have Terraform and tflint installed):

```bash
# Test Terraform validate with -chdir
for module in modules/*/; do
  terraform -chdir="$module" init -backend=false
  terraform -chdir="$module" validate
done

# Test tflint with --chdir
for module in modules/*/; do
  tflint --init --chdir="$module"
  tflint --chdir="$module"
done
```

## Notes

- The `test-validation.yml` workflow uses `cd` to change directories, which is also valid and works correctly
- Both approaches (`-chdir`/`--chdir` and `cd`) are acceptable, but `-chdir`/`--chdir` is preferred for newer versions
- The fixes maintain compatibility with Terraform >= 1.2.2 and tflint >= 0.47

