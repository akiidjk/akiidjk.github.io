import { useEffect } from 'react';

export default function ModalController() {
  useEffect(() => {
    const openBtn = document.getElementById('open-search');
    const modal = document.getElementById('search-modal');
    const closeBtn = modal?.querySelector('.close-btn');

    if (modal && openBtn) {
      const openHandler = () => {
        modal.classList.add('active');
        const input = modal.querySelector("input[type='text']");
        if (input instanceof HTMLInputElement) input.focus();
      };

      const closeHandler = () => modal.classList.remove('active');

      openBtn.addEventListener('click', openHandler);
      closeBtn?.addEventListener('click', closeHandler);

      // cleanup
      return () => {
        openBtn.removeEventListener('click', openHandler);
        closeBtn?.removeEventListener('click', closeHandler);
      };
    }
  }, []);

  return null;
}
