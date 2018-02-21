# monroe-bench
Test-harness for QMUL at Monroe CamCow (Characterising Mobile Content Networks in the Wild) Network of Excellence project.

## Requirements
pip install -r requirements.txt

## Example usage of cli wrapper script
python3.6 src/deploy_experiment.py -i helloworld -o output
  create
    --name helloworld --testing --countries Spain --start 2017-08-01T17:30:00 --availability

List of tasks:
- [X] Define container image/s: using the monroe/based image with the test-harness in the qmmonroe folder (deployed into container) developed by Dr. Alvaro Garcia-Recuero at QMUL.
- [ ] Explore and set up Message Brokering architecture (push-pull model, microservices, etc): deemed unncessary after requirement evaluation.
- [ ] Integrate [monroe-cli](https://github.com/ana-cc/monroe-cli) tools into our benchmark: Work in progress.
- [X] Define list of measurements (can always be updated, see [gdrive document](https://docs.google.com/document/d/1C720lVlNVgbx8Nvs_qiAEeU-YMZtW7hS57odvq490x4/edit?usp=drive_web) )
- [X] Set up plotting infrastructure
- [X] Benchmark Monroe using our test harness with some sample experiments/configurations: we have run a series of automated experiments (ping, traceroute, curl, dig) in the Monroe platform using the test-harness in the qmmonroe folder (deployed into container) developed by Dr. Alvaro Garcia-Recuero at QMUL.
