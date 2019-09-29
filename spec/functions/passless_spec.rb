require 'spec_helper'

describe :passless do
  it { is_expected.to run.with_params('foo').and_return('qaz123') }
end
