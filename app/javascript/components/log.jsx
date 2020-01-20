import React, {Component} from 'react';
import PropTypes from 'prop-types';

const Response = props => {
  if (!props.data || !props.data.response) {
    return null;
  }

  return (
    <div className="log-entry log-entry--response">
      <p>{props.data.response.output_speech.text}</p>
    </div>
  );
};

class Request extends Component {
  get data() {
    return this.props.data || {};
  }

  get request() {
    return this.data.request || {};
  }

  get intent() {
    return this.request.intent && this.request.intent.name;
  }

  get slots() {
    if (!this.intent || !this.intent.slots) {
      return [];
    }
    return Object.keys(this.intent.slots || {}).map(key => {
      const slot = this.intent.slots[key];
      return {name: slot.name, value: slot.value};
    });
  }

  render() {
    return (
      <div className="log-entry log-entry--request" style={{maxWidth: '30rem'}}>
        <p>
          [{this.props.created_at}] {this.intent || this.request.type}
        </p>
        <ul>
          {this.slots.map(slot => (
            <li key={slot.name}>
              {slot.name}: {slot.value}
            </li>
          ))}
        </ul>
        <p style={{fontSize: '.75rem'}}>
          {JSON.stringify(this.props, null, 4)}
        </p>
      </div>
    );
  }
}

const Log = data => {
  const log = {
    response: () => <Response {...data} />,
    request: () => <Request {...data} />,
  }[data.type];

  if (!log) {
    return <div className="log-entry">{data.request && data.request.type}</div>;
  }

  return log();
};

export default Log;
