import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';

import actions from 'actions';

const Passage = ({active, onUpdate}) => {
  const [passage, setPassage] = useState({title: '', body: '', choices: []});

  useEffect(() => {
    if (!active) {
      return;
    }

    actions.fetchPassage(active).then(passage => {
      setPassage({
        title: passage.story.title,
        body: passage.text,
        choices: passage.choices,
      });
    });
  }, [active]);

  console.debug(passage.choices);
  return (
    <section className="passage">
      <h2>{passage.title}</h2>
      <p>{passage.body}</p>
      <hr />
      <ol className="choices">
        {passage.choices.map(choice => (
          <li key={choice.ref}>
            <a tabIndex={0} onClick={() => onUpdate(choice)} role="button">
              {choice.label}
            </a>
          </li>
        ))}
      </ol>
    </section>
  );
};

Passage.propTypes = {
  active: PropTypes.object,
  onUpdate: PropTypes.func.isRequired,
};

export default Passage;
