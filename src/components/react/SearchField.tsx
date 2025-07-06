import React, { useEffect } from 'react';

interface Props {
  readonly id?: string;
  readonly className?: string;
}

const SearchField: React.FC<Props> = ({ id, className }) => {
  const bundlePath = `${import.meta.env.BASE_URL}pagefind/`;

  useEffect(() => {
    const setupPagefind = async () => {
      const { PagefindUI } = await import('@pagefind/default-ui');
      const elements = document.querySelectorAll('[data-pagefind-ui]');

      elements.forEach((el) => {
        new PagefindUI({
          element: el,
          bundlePath,
          showImages: false,
          debounceTimeoutMs: 100,
        });

        const input = el.querySelector<HTMLInputElement>('input[type="text"]');
        input?.focus();

        const url = new URL(window.location.href);
        const params = new URLSearchParams(url.search);
        const query = params.get('q');

        if (query && input) {
          input.value = query;
          input.dispatchEvent(new Event('input', { bubbles: true }));
        }

        input?.addEventListener('input', (e) => {
          const input = e.target as HTMLInputElement;
          const url = new URL(window.location.href);
          const params = new URLSearchParams(url.search);
          params.set('q', input.value);
          window.history.replaceState({}, '', `${url.pathname}?${params}`);
        });
      });
    };

    setupPagefind();
  }, [bundlePath]);

  return (
    <div
      {...(id ? { id } : {})}
      {...(className ? { className } : {})}
      data-pagefind-ui
      data-bundle-path={bundlePath}
    ></div>
  );
};

export default SearchField;
