import json
from typing import Any
from typing import Iterable
from typing import Mapping
from typing import Optional
from typing import Sequence

import semgrep.semgrep_interfaces.semgrep_output_v1 as out
from semgrep.error import SemgrepError
from semgrep.formatter.base import BaseFormatter
from semgrep.rule import Rule
from semgrep.rule_match import RuleMatch


# This is for converting instances of classes generated by atdpy, which
# all have a 'to_json' method.
def to_json(x: Any) -> Any:
    return x.to_json()


class CiScanResultsFormatter(BaseFormatter):
    def format(
        self,
        rules: Iterable[Rule],
        rule_matches: Iterable[RuleMatch],
        semgrep_structured_errors: Sequence[SemgrepError],
        cli_output_extra: out.CliOutputExtra,
        extra: Mapping[str, Any],
        is_ci_invocation: bool,
        ci_scan_results: Optional[out.CiScanResults],
    ) -> str:
        return json.dumps(
            ci_scan_results.to_json() if ci_scan_results else {},
            sort_keys=True,
            default=to_json,
        )
