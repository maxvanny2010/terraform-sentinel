# GitHub Pull Request History

This document records the development of the Terraform and Sentinel policy-as-code project.
Pull Requests #1 to #15 have been merged into `master`.
PR #16 contains the final README updates and this Pull Request history document.

<table>
  <thead>
    <tr><th>PR</th><th>Change</th><th>Documented implementation</th><th>Status</th></tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/1">#1</a></td>
      <td>chore: initialize project structure</td>
      <td>Initial repository structure</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/2">#2</a></td>
      <td>feat: implement secure Terraform infrastructure</td>
      <td>Terraform infrastructure configuration</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/3">#3</a></td>
      <td>feat: Enforce AWS Region Restrictions with Sentinel</td>
      <td>AWS region policy</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/4">#4</a></td>
      <td>fix: Merge AWS Region Sentinel Policy into Master</td>
      <td>AWS region policy integration</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/5">#5</a></td>
      <td>feat: Enforce EC2 Security Requirements with Sentinel</td>
      <td>EC2 security policy</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/6">#6</a></td>
      <td>feat: Enforce Terraform Supply Chain Security with Sentinel</td>
      <td>Terraform supply chain policy</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/7">#7</a></td>
      <td>feat: enforce network security with Sentinel policy</td>
      <td>Network security policy</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/8">#8</a></td>
      <td>docs: document HCP Terraform plan, deployment and infrastructure cleanup</td>
      <td>Plan, Apply and Destroy evidence</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/9">#9</a></td>
      <td>docs: complete technical report</td>
      <td>Technical report</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/10">#10</a></td>
      <td>docs: improve README formatting and test result badges</td>
      <td>README formatting and test badges</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/11">#11</a></td>
      <td>docs: finalize README formatting</td>
      <td>README formatting</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/12">#12</a></td>
      <td>refactor: parameterize VPC and subnet CIDR blocks</td>
      <td>Configurable network CIDR blocks</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/13">#13</a></td>
      <td>docs: clarify network CIDR validation</td>
      <td>Network CIDR validation documentation</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/14">#14</a></td>
      <td>docs: finalize Terraform Sentinel assignment evidence and documentation</td>
      <td>Assignment evidence and documentation</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/15">#15</a></td>
      <td>docs: finalize README validation badges and AI assistance disclosure</td>
      <td>Test badges and AI assistance disclosure</td>
      <td>Merged</td>
    </tr>
    <tr>
      <td><a href="https://github.com/maxvanny2010/terraform-sentinel/pull/16">#16</a></td>
      <td>docs: finalize README and pull request history</td>
      <td>Final README and Pull Request history</td>
      <td>Merged</td>
    </tr>
  </tbody>
</table>

## Review Changes

Open a Pull Request link above and select **Files changed** to inspect the implementation.
The Pull Request timeline provides the associated commits, review activity and merge history.

## Project Status

The project defines seven AWS resources and four `hard-mandatory` Sentinel policies.
Local validation covered 23 Sentinel test scenarios.
HCP Terraform successfully planned, deployed, verified and destroyed the test infrastructure.
All seven Terraform-managed AWS resources were removed after validation.
