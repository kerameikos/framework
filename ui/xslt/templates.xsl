<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:template name="header">
		<xsl:variable name="json1">
			<xsl:text>{"overlayOpenedBy":{"click":false,"hover":false,"focus":false},"type":"overlay","roleAttribute":"","ariaLabel":"Menu"}</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="json2">
			<xsl:text>{ &quot;submenuOpenedBy&quot;: { &quot;click&quot;: false, &quot;hover&quot;: false, &quot;focus&quot;: false }, &quot;type&quot;: &quot;submenu&quot;, &quot;modal&quot;: null, &quot;previousFocus&quot;: null }</xsl:text>
		</xsl:variable>

		<header class="wp-block-template-part">
			<div class="wp-block-group alignfull has-global-padding is-layout-constrained wp-block-group-is-layout-constrained">
				<div class="wp-block-group alignfull has-global-padding is-layout-constrained wp-container-core-group-is-layout-19e250f3 wp-block-group-is-layout-constrained">
					<div class="wp-block-group alignfull has-global-padding is-layout-constrained wp-container-core-group-is-layout-19e250f3 wp-block-group-is-layout-constrained">
						<div class="wp-block-group alignfull is-layout-flow wp-block-group-is-layout-flow">
							<div
								class="wp-block-group alignfull has-global-padding is-layout-constrained wp-container-core-group-is-layout-19e250f3 wp-block-group-is-layout-constrained">
								<div
									class="wp-block-group alignfull has-global-padding is-layout-constrained wp-container-core-group-is-layout-19e250f3 wp-block-group-is-layout-constrained">
									<div
										class="wp-block-group alignfull has-background-color has-custom-eggshell-color has-text-color has-background has-link-color wp-elements-05d43b6fd045381f4e5b4258cb5dfd2c is-layout-flow wp-container-core-group-is-layout-ddaf840a wp-block-group-is-layout-flow"
										style="background-color:#1d1c22;padding-top:var(--wp--preset--spacing--40);padding-right:var(--wp--preset--spacing--40);padding-bottom:var(--wp--preset--spacing--20);padding-left:var(--wp--preset--spacing--40)">
										<div
											class="wp-block-group alignwide has-base-color has-text-color has-link-color wp-elements-96bba6e487e230c38aa87bfb36176316 is-content-justification-space-between is-nowrap is-layout-flex wp-container-core-group-is-layout-78c6040a wp-block-group-is-layout-flex"
											style="margin-top:0;margin-bottom:0">
											<div
												class="wp-block-group has-custom-pearl-color has-text-color has-link-color wp-elements-2465b3b57bdb399e093928f6e7c43f21 is-layout-flex wp-block-group-is-layout-flex">
												<div class="wp-block-site-logo">
													<a href="https://kerameikos.org/" class="custom-logo-link" rel="home">
														<img width="74" height="74" src="https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-scaled.png" class="custom-logo"
															alt="kerameikos.org" decoding="async"
															srcset="https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-scaled.png 2560w, https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-300x300.png 300w, https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-1024x1024.png 1024w, https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-150x150.png 150w, https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-768x768.png 768w, https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-1536x1536.png 1536w, https://kerameikos.org/wp-content/uploads/2025/10/logo-bf-1-2048x2048.png 2048w"
															sizes="(max-width: 74px) 100vw, 74px"/>
													</a>
												</div>

												<h1 style="font-size:clamp(24.034px, 1.502rem + ((1vw - 3.2px) * 1.565), 40px);"
													class="has-link-color wp-elements-2e19baad4cc787ca0f3b34e82b7a7aa3 wp-block-site-title has-text-color has-base-color">
													<a href="https://kerameikos.org" target="_self" rel="home">kerameikos.org</a>
												</h1>
											</div>



											<div
												class="wp-block-group has-custom-pearl-color has-text-color has-link-color wp-elements-63170f6cfc92695cd7d38d2317310ce1 is-layout-flex wp-block-group-is-layout-flex">
												<nav
													class="has-text-color has-base-color is-responsive items-justified-right wp-block-navigation is-horizontal is-content-justification-right is-layout-flex wp-container-core-navigation-is-layout-64619e5e wp-block-navigation-is-layout-flex"
													aria-label="Navigation" data-wp-interactive="core/navigation" data-wp-context="{$json1}">
													<button aria-haspopup="dialog" aria-label="Open menu" class="wp-block-navigation__responsive-container-open"
														data-wp-on--click="actions.openMenuOnClick" data-wp-on--keydown="actions.handleMenuKeydown">
														<svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
															<path d="M4 7.5h16v1.5H4z"/>
															<path d="M4 15h16v1.5H4z"/>
														</svg>
													</button>
													<div
														class="wp-block-navigation__responsive-container  has-text-color has-base-color has-background has-custom-basalt-background-color"
														id="modal-1" data-wp-class--has-modal-open="state.isMenuOpen" data-wp-class--is-menu-open="state.isMenuOpen"
														data-wp-watch="callbacks.initMenu" data-wp-on--keydown="actions.handleMenuKeydown"
														data-wp-on--focusout="actions.handleMenuFocusout" tabindex="-1">
														<div class="wp-block-navigation__responsive-close" tabindex="-1">
															<div class="wp-block-navigation__responsive-dialog" data-wp-bind--aria-modal="state.ariaModal"
																data-wp-bind--aria-label="state.ariaLabel" data-wp-bind--role="state.roleAttribute">
																<button aria-label="Close menu" class="wp-block-navigation__responsive-container-close"
																	data-wp-on--click="actions.closeMenuOnClick">
																	<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" aria-hidden="true"
																		focusable="false">
																		<path
																			d="m13.06 12 6.47-6.47-1.06-1.06L12 10.94 5.53 4.47 4.47 5.53 10.94 12l-6.47 6.47 1.06 1.06L12 13.06l6.47 6.47 1.06-1.06L13.06 12Z"
																		/>
																	</svg>
																</button>
																<div class="wp-block-navigation__responsive-container-content" data-wp-watch="callbacks.focusFirstElement"
																	id="modal-1-content">
																	<ul
																		class="wp-block-navigation__container has-text-color has-base-color is-responsive items-justified-right wp-block-navigation">
																		<li class=" wp-block-navigation-item wp-block-navigation-link has-medium-font-size">
																			<a class="wp-block-navigation-item__content" href="https://kerameikos.org/browse">
																				<span class="wp-block-navigation-item__label">Search</span>
																			</a>
																		</li>
																		<li data-wp-context="{$json2}" data-wp-interactive="core/navigation"
																			data-wp-on--focusout="actions.handleMenuFocusout" data-wp-on--keydown="actions.handleMenuKeydown"
																			data-wp-on--mouseenter="actions.openMenuOnHover" data-wp-on--mouseleave="actions.closeMenuOnHover"
																			data-wp-watch="callbacks.initMenu" tabindex="-1"
																			class="wp-block-navigation-item has-child open-on-hover-click wp-block-navigation-submenu has-medium-font-size">
																			<a class="wp-block-navigation-item__content" href="https://kerameikos.org/?page_id=116">
																				<span class="wp-block-navigation-item__label">How to Use</span>
																			</a>
																			<button data-wp-bind--aria-expanded="state.isMenuOpen" data-wp-on--click="actions.toggleMenuOnClick"
																				aria-label="How to Use submenu"
																				class="wp-block-navigation__submenu-icon wp-block-navigation-submenu__toggle">
																				<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none"
																					aria-hidden="true" focusable="false">
																					<path d="M1.50002 4L6.00002 8L10.5 4" stroke-width="1.5"/>
																				</svg>
																			</button>
																			<ul data-wp-on--focus="actions.openMenuOnFocus"
																				class="wp-block-navigation__submenu-container has-text-color has-base-color has-background has-custom-basalt-background-color wp-block-navigation-submenu has-medium-font-size">
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/using-our-search/">
																						<span class="wp-block-navigation-item__label">Using Our Search</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/our-terminology/">
																						<span class="wp-block-navigation-item__label">Our Terminology</span>
																					</a>
																				</li>
																			</ul>
																		</li>
																		<li data-wp-context="{$json2}" data-wp-interactive="core/navigation"
																			data-wp-on--focusout="actions.handleMenuFocusout" data-wp-on--keydown="actions.handleMenuKeydown"
																			data-wp-on--mouseenter="actions.openMenuOnHover" data-wp-on--mouseleave="actions.closeMenuOnHover"
																			data-wp-watch="callbacks.initMenu" tabindex="-1"
																			class="wp-block-navigation-item has-child open-on-hover-click wp-block-navigation-submenu">
																			<a class="wp-block-navigation-item__content">
																				<span class="wp-block-navigation-item__label">Resources</span>
																			</a>
																			<button data-wp-bind--aria-expanded="state.isMenuOpen" data-wp-on--click="actions.toggleMenuOnClick"
																				aria-label="Resources submenu"
																				class="wp-block-navigation__submenu-icon wp-block-navigation-submenu__toggle">
																				<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none"
																					aria-hidden="true" focusable="false">
																					<path d="M1.50002 4L6.00002 8L10.5 4" stroke-width="1.5"/>
																				</svg>
																			</button>
																			<ul data-wp-on--focus="actions.openMenuOnFocus"
																				class="wp-block-navigation__submenu-container has-text-color has-base-color has-background has-custom-basalt-background-color wp-block-navigation-submenu">
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/greek-vases/">
																						<span class="wp-block-navigation-item__label">What is a Greek Vase?</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/lod/">
																						<span class="wp-block-navigation-item__label">What is LOD?</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content"
																						href="https://kerameikos.org/publications-presentations/">
																						<span class="wp-block-navigation-item__label">Publications &amp; Presentations</span>
																					</a>
																				</li>
																			</ul>
																		</li>
																		<li class=" wp-block-navigation-item wp-block-navigation-link has-medium-font-size">
																			<a class="wp-block-navigation-item__content" href="https://kerameikos.org/?page_id=120">
																				<span class="wp-block-navigation-item__label">Blog</span>
																			</a>
																		</li>
																		<li data-wp-context="{$json2}" data-wp-interactive="core/navigation"
																			data-wp-on--focusout="actions.handleMenuFocusout" data-wp-on--keydown="actions.handleMenuKeydown"
																			data-wp-on--mouseenter="actions.openMenuOnHover" data-wp-on--mouseleave="actions.closeMenuOnHover"
																			data-wp-watch="callbacks.initMenu" tabindex="-1"
																			class="wp-block-navigation-item has-child open-on-hover-click wp-block-navigation-submenu has-text-color has-base-color has-background has-custom-baltic-background-color">
																			<a class="wp-block-navigation-item__content">
																				<span class="wp-block-navigation-item__label">Data</span>
																			</a>
																			<button data-wp-bind--aria-expanded="state.isMenuOpen" data-wp-on--click="actions.toggleMenuOnClick"
																				aria-label="Data submenu"
																				class="wp-block-navigation__submenu-icon wp-block-navigation-submenu__toggle">
																				<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none"
																					aria-hidden="true" focusable="false">
																					<path d="M1.50002 4L6.00002 8L10.5 4" stroke-width="1.5"/>
																				</svg>
																			</button>
																			<ul data-wp-on--focus="actions.openMenuOnFocus"
																				class="wp-block-navigation__submenu-container has-text-color has-base-color has-background has-custom-basalt-background-color wp-block-navigation-submenu has-text-color has-base-color has-background has-custom-baltic-background-color">
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/datasets">
																						<span class="wp-block-navigation-item__label">Datasets</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/ontology">
																						<span class="wp-block-navigation-item__label">Ontology</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/apis/">
																						<span class="wp-block-navigation-item__label">APIs</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/sparql">
																						<span class="wp-block-navigation-item__label">SPARQL</span>
																					</a>
																				</li>
																			</ul>
																		</li>
																		<li data-wp-context="{$json2}" data-wp-interactive="core/navigation"
																			data-wp-on--focusout="actions.handleMenuFocusout" data-wp-on--keydown="actions.handleMenuKeydown"
																			data-wp-on--mouseenter="actions.openMenuOnHover" data-wp-on--mouseleave="actions.closeMenuOnHover"
																			data-wp-watch="callbacks.initMenu" tabindex="-1"
																			class="wp-block-navigation-item has-child open-on-hover-click wp-block-navigation-submenu current-menu-ancestor">
																			<a class="wp-block-navigation-item__content">
																				<span class="wp-block-navigation-item__label">About</span>
																			</a>
																			<button data-wp-bind--aria-expanded="state.isMenuOpen" data-wp-on--click="actions.toggleMenuOnClick"
																				aria-label="About submenu"
																				class="wp-block-navigation__submenu-icon wp-block-navigation-submenu__toggle">
																				<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none"
																					aria-hidden="true" focusable="false">
																					<path d="M1.50002 4L6.00002 8L10.5 4" stroke-width="1.5"/>
																				</svg>
																			</button>
																			<ul data-wp-on--focus="actions.openMenuOnFocus"
																				class="wp-block-navigation__submenu-container has-text-color has-base-color has-background has-custom-basalt-background-color wp-block-navigation-submenu">
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/our-history/">
																						<span class="wp-block-navigation-item__label">Our History</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item current-menu-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/meet-the-team/"
																						aria-current="page">
																						<span class="wp-block-navigation-item__label">Meet the Team</span>
																					</a>
																				</li>
																				<li class=" wp-block-navigation-item wp-block-navigation-link">
																					<a class="wp-block-navigation-item__content" href="https://kerameikos.org/contact-us/">
																						<span class="wp-block-navigation-item__label">Contact Us</span>
																					</a>
																				</li>
																			</ul>
																		</li>
																	</ul>
																</div>
															</div>
														</div>
													</div>
												</nav>
											</div>
										</div>
									</div>



									<figure class="wp-block-image alignfull size-full">
										<img fetchpriority="high" decoding="async" width="2560" height="79"
											src="https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-scaled.png" alt="" class="wp-image-623"
											srcset="https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-scaled.png 2560w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-300x9.png 300w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-1024x32.png 1024w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-768x24.png 768w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-1536x48.png 1536w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-2048x63.png 2048w"
											sizes="(max-width: 2560px) 100vw, 2560px"/>
									</figure>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</header>

	</xsl:template>

	<xsl:template name="footer">
		<footer class="wp-block-template-part">
			<div class="wp-block-group alignfull has-global-padding is-layout-constrained wp-container-core-group-is-layout-19e250f3 wp-block-group-is-layout-constrained">
				<div class="wp-block-group alignfull has-global-padding is-layout-constrained wp-container-core-group-is-layout-19e250f3 wp-block-group-is-layout-constrained">
					<figure class="wp-block-image alignfull size-full">
						<img loading="lazy" decoding="async" width="2560" height="79" src="https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-scaled.png" alt=""
							class="wp-image-623"
							srcset="https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-scaled.png 2560w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-300x9.png 300w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-1024x32.png 1024w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-768x24.png 768w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-1536x48.png 1536w, https://kerameikos.org/wp-content/uploads/2025/10/meander-banner-crop-2048x63.png 2048w"
							sizes="auto, (max-width: 2560px) 100vw, 2560px"/>
					</figure>



					<div
						class="wp-block-group alignfull has-background-color has-base-color has-custom-baltic-background-color has-text-color has-background is-layout-flow wp-block-group-is-layout-flow"
						style="margin-top:0;margin-bottom:0;padding-top:var(--wp--preset--spacing--20);padding-right:var(--wp--preset--spacing--50);padding-bottom:var(--wp--preset--spacing--50);padding-left:var(--wp--preset--spacing--50)">
						<div style="height:8px" aria-hidden="true" class="wp-block-spacer"/>


						<h1
							class="has-text-align-center has-link-color wp-elements-c274abde050f7aac1c729484c8424fe2 wp-block-site-title has-text-color has-custom-eggshell-color has-large-font-size wp-container-content-b0223bd5">
							<a href="https://kerameikos.org" target="_self" rel="home">kerameikos.org</a>
						</h1>


						<div
							class="wp-block-group has-base-color has-text-color has-link-color wp-elements-53866209a0a6fcae0356d149a44ff039 is-vertical is-content-justification-center is-layout-flex wp-container-core-group-is-layout-3d16a5d4 wp-block-group-is-layout-flex">
							<ul
								class="wp-block-social-links has-normal-icon-size has-visible-labels has-icon-color is-style-logos-only wp-container-content-b0223bd5 is-horizontal is-content-justification-center is-layout-flex wp-container-core-social-links-is-layout-845a9879 wp-block-social-links-is-layout-flex">

								<li style="color:#e9e5e4;" class="wp-social-link wp-social-link-github has-custom-eggshell-color wp-block-social-link">
									<a href="https://github.com/kerameikos" class="wp-block-social-link-anchor">
										<svg width="24" height="24" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false">
											<path
												d="M12,2C6.477,2,2,6.477,2,12c0,4.419,2.865,8.166,6.839,9.489c0.5,0.09,0.682-0.218,0.682-0.484 c0-0.236-0.009-0.866-0.014-1.699c-2.782,0.602-3.369-1.34-3.369-1.34c-0.455-1.157-1.11-1.465-1.11-1.465 c-0.909-0.62,0.069-0.608,0.069-0.608c1.004,0.071,1.532,1.03,1.532,1.03c0.891,1.529,2.341,1.089,2.91,0.833 c0.091-0.647,0.349-1.086,0.635-1.337c-2.22-0.251-4.555-1.111-4.555-4.943c0-1.091,0.39-1.984,1.03-2.682 C6.546,8.54,6.202,7.524,6.746,6.148c0,0,0.84-0.269,2.75,1.025C10.295,6.95,11.15,6.84,12,6.836 c0.85,0.004,1.705,0.114,2.504,0.336c1.909-1.294,2.748-1.025,2.748-1.025c0.546,1.376,0.202,2.394,0.1,2.646 c0.64,0.699,1.026,1.591,1.026,2.682c0,3.841-2.337,4.687-4.565,4.935c0.359,0.307,0.679,0.917,0.679,1.852 c0,1.335-0.012,2.415-0.012,2.741c0,0.269,0.18,0.579,0.688,0.481C19.138,20.161,22,16.416,22,12C22,6.477,17.523,2,12,2z"
											/>
										</svg>
										<span class="wp-block-social-link-label">GitHub</span>
									</a>
								</li>

								<li style="color:#e9e5e4;" class="wp-social-link wp-social-link-mail has-custom-eggshell-color wp-block-social-link">
									<a href="mailto:#&#107;era&#109;&#101;&#105;k&#111;&#115;.&#111;rg&#064;g&#109;ail.&#099;o&#109;" class="wp-block-social-link-anchor">
										<svg width="24" height="24" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false">
											<path
												d="M19,5H5c-1.1,0-2,.9-2,2v10c0,1.1.9,2,2,2h14c1.1,0,2-.9,2-2V7c0-1.1-.9-2-2-2zm.5,12c0,.3-.2.5-.5.5H5c-.3,0-.5-.2-.5-.5V9.8l7.5,5.6,7.5-5.6V17zm0-9.1L12,13.6,4.5,7.9V7c0-.3.2-.5.5-.5h14c.3,0,.5.2.5.5v.9z"
											/>
										</svg>
										<span class="wp-block-social-link-label">Mail</span>
									</a>
								</li>
							</ul>
						</div>

						<div
							class="wp-block-group has-base-color has-text-color has-link-color wp-elements-b6cd64af30ee757b05b6f212daaaffa6 wp-container-content-9cfa9a5a is-vertical is-content-justification-center is-layout-flex wp-container-core-group-is-layout-ce155fab wp-block-group-is-layout-flex">
							<p class="has-text-align-center has-small-font-size"> Kerameikos.org data are made available under the <a
									href="http://opendatacommons.org/licenses/odbl/1.0/">Open Database License</a>. See <a href="datasets">datasets</a> for image rights, respective
								to individual institution.</p>
						</div>
					</div>
				</div>
			</div>
		</footer>
	</xsl:template>

	<xsl:template name="wordpress-css">
		<xsl:variable name="json3">
			<xsl:text>{&quot;loadOnClientNavigation&quot;:true}</xsl:text>
		</xsl:variable>
		
		<style id="admin-bar-inline-css">
			@media screen {
			    html {
			        margin-top: 32px !important;
			    }
			}
			@media screen and (max-width : 782px) {
			    html {
			        margin-top: 46px !important;
			    }
			}
			
			@media print {
			    #wpadminbar {
			        display: none;
			    }
			}
			/*# sourceURL=admin-bar-inline-css */</style>
		<style id="wp-block-site-logo-inline-css">
			.wp-block-site-logo{box-sizing:border-box;line-height:0}.wp-block-site-logo a{display:inline-block;line-height:0}.wp-block-site-logo.is-default-size img{height:auto;width:120px}.wp-block-site-logo img{height:auto;max-width:100%}.wp-block-site-logo a,.wp-block-site-logo img{border-radius:inherit}.wp-block-site-logo.aligncenter{margin-left:auto;margin-right:auto;text-align:center}:root :where(.wp-block-site-logo.is-style-rounded){border-radius:9999px}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/site-logo/style.min.css */
		</style>
		<style id="wp-block-site-title-inline-css">
			.wp-block-site-title {
			    box-sizing: border-box
			}
			.wp-block-site-title :where(a) {
			    color: inherit;
			    font-family: inherit;
			    font-size: inherit;
			    font-style: inherit;
			    font-weight: inherit;
			    letter-spacing: inherit;
			    line-height: inherit;
			    text-decoration: inherit
			}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/site-title/style.min.css */</style>
		<style id="wp-block-group-inline-css">
			.wp-block-group{box-sizing:border-box}:where(.wp-block-group.wp-block-group-is-layout-constrained){position:relative}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/group/style.min.css */
		</style>
		<style id="wp-block-navigation-link-inline-css">
			.wp-block-navigation .wp-block-navigation-item__label {
			    overflow-wrap: break-word
			}
			.wp-block-navigation .wp-block-navigation-item__description {
			    display: none
			}
			.link-ui-tools {
			    outline: 1px solid #f0f0f0;
			    padding: 8px
			}
			.link-ui-block-inserter {
			    padding-top: 8px
			}
			.link-ui-block-inserter__back {
			    margin-left: 8px;
			    text-transform: uppercase
			}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/navigation-link/style.min.css */</style>
		<link rel="stylesheet" id="wp-block-navigation-css" href="https://kerameikos.org/wp-includes/blocks/navigation/style.min.css?ver=6.9.1" media="all"/>
		<style id="wp-block-image-inline-css">
			.wp-block-image>a,.wp-block-image>figure>a{display:inline-block}.wp-block-image img{box-sizing:border-box;height:auto;max-width:100%;vertical-align:bottom}@media not (prefers-reduced-motion){.wp-block-image img.hide{visibility:hidden}.wp-block-image img.show{animation:show-content-image .4s}}.wp-block-image[style*=border-radius] img,.wp-block-image[style*=border-radius]>a{border-radius:inherit}.wp-block-image.has-custom-border img{box-sizing:border-box}.wp-block-image.aligncenter{text-align:center}.wp-block-image.alignfull>a,.wp-block-image.alignwide>a{width:100%}.wp-block-image.alignfull img,.wp-block-image.alignwide img{height:auto;width:100%}.wp-block-image .aligncenter,.wp-block-image .alignleft,.wp-block-image .alignright,.wp-block-image.aligncenter,.wp-block-image.alignleft,.wp-block-image.alignright{display:table}.wp-block-image .aligncenter>figcaption,.wp-block-image .alignleft>figcaption,.wp-block-image .alignright>figcaption,.wp-block-image.aligncenter>figcaption,.wp-block-image.alignleft>figcaption,.wp-block-image.alignright>figcaption{caption-side:bottom;display:table-caption}.wp-block-image .alignleft{float:left;margin:.5em 1em .5em 0}.wp-block-image .alignright{float:right;margin:.5em 0 .5em 1em}.wp-block-image .aligncenter{margin-left:auto;margin-right:auto}.wp-block-image :where(figcaption){margin-bottom:1em;margin-top:.5em}.wp-block-image.is-style-circle-mask img{border-radius:9999px}@supports ((-webkit-mask-image:none) or (mask-image:none)) or (-webkit-mask-image:none){.wp-block-image.is-style-circle-mask img{border-radius:0;-webkit-mask-image:url('data:image/svg+xml;utf8,<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="50"/></svg>');mask-image:url('data:image/svg+xml;utf8,<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="50"/></svg>');mask-mode:alpha;-webkit-mask-position:center;mask-position:center;-webkit-mask-repeat:no-repeat;mask-repeat:no-repeat;-webkit-mask-size:contain;mask-size:contain}}:root :where(.wp-block-image.is-style-rounded img,.wp-block-image .is-style-rounded img){border-radius:9999px}.wp-block-image figure{margin:0}.wp-lightbox-container{display:flex;flex-direction:column;position:relative}.wp-lightbox-container img{cursor:zoom-in}.wp-lightbox-container img:hover+button{opacity:1}.wp-lightbox-container button{align-items:center;backdrop-filter:blur(16px) saturate(180%);background-color:#5a5a5a40;border:none;border-radius:4px;cursor:zoom-in;display:flex;height:20px;justify-content:center;opacity:0;padding:0;position:absolute;right:16px;text-align:center;top:16px;width:20px;z-index:100}@media not (prefers-reduced-motion){.wp-lightbox-container button{transition:opacity .2s ease}}.wp-lightbox-container button:focus-visible{outline:3px auto #5a5a5a40;outline:3px auto -webkit-focus-ring-color;outline-offset:3px}.wp-lightbox-container button:hover{cursor:pointer;opacity:1}.wp-lightbox-container button:focus{opacity:1}.wp-lightbox-container button:focus,.wp-lightbox-container button:hover,.wp-lightbox-container button:not(:hover):not(:active):not(.has-background){background-color:#5a5a5a40;border:none}.wp-lightbox-overlay{box-sizing:border-box;cursor:zoom-out;height:100vh;left:0;overflow:hidden;position:fixed;top:0;visibility:hidden;width:100%;z-index:100000}.wp-lightbox-overlay .close-button{align-items:center;cursor:pointer;display:flex;justify-content:center;min-height:40px;min-width:40px;padding:0;position:absolute;right:calc(env(safe-area-inset-right) + 16px);top:calc(env(safe-area-inset-top) + 16px);z-index:5000000}.wp-lightbox-overlay .close-button:focus,.wp-lightbox-overlay .close-button:hover,.wp-lightbox-overlay .close-button:not(:hover):not(:active):not(.has-background){background:none;border:none}.wp-lightbox-overlay .lightbox-image-container{height:var(--wp--lightbox-container-height);left:50%;overflow:hidden;position:absolute;top:50%;transform:translate(-50%,-50%);transform-origin:top left;width:var(--wp--lightbox-container-width);z-index:9999999999}.wp-lightbox-overlay .wp-block-image{align-items:center;box-sizing:border-box;display:flex;height:100%;justify-content:center;margin:0;position:relative;transform-origin:0 0;width:100%;z-index:3000000}.wp-lightbox-overlay .wp-block-image img{height:var(--wp--lightbox-image-height);min-height:var(--wp--lightbox-image-height);min-width:var(--wp--lightbox-image-width);width:var(--wp--lightbox-image-width)}.wp-lightbox-overlay .wp-block-image figcaption{display:none}.wp-lightbox-overlay button{background:none;border:none}.wp-lightbox-overlay .scrim{background-color:#fff;height:100%;opacity:.9;position:absolute;width:100%;z-index:2000000}.wp-lightbox-overlay.active{visibility:visible}@media not (prefers-reduced-motion){.wp-lightbox-overlay.active{animation:turn-on-visibility .25s both}.wp-lightbox-overlay.active img{animation:turn-on-visibility .35s both}.wp-lightbox-overlay.show-closing-animation:not(.active){animation:turn-off-visibility .35s both}.wp-lightbox-overlay.show-closing-animation:not(.active) img{animation:turn-off-visibility .25s both}.wp-lightbox-overlay.zoom.active{animation:none;opacity:1;visibility:visible}.wp-lightbox-overlay.zoom.active .lightbox-image-container{animation:lightbox-zoom-in .4s}.wp-lightbox-overlay.zoom.active .lightbox-image-container img{animation:none}.wp-lightbox-overlay.zoom.active .scrim{animation:turn-on-visibility .4s forwards}.wp-lightbox-overlay.zoom.show-closing-animation:not(.active){animation:none}.wp-lightbox-overlay.zoom.show-closing-animation:not(.active) .lightbox-image-container{animation:lightbox-zoom-out .4s}.wp-lightbox-overlay.zoom.show-closing-animation:not(.active) .lightbox-image-container img{animation:none}.wp-lightbox-overlay.zoom.show-closing-animation:not(.active) .scrim{animation:turn-off-visibility .4s forwards}}@keyframes show-content-image{0%{visibility:hidden}99%{visibility:hidden}to{visibility:visible}}@keyframes turn-on-visibility{0%{opacity:0}to{opacity:1}}@keyframes turn-off-visibility{0%{opacity:1;visibility:visible}99%{opacity:0;visibility:visible}to{opacity:0;visibility:hidden}}@keyframes lightbox-zoom-in{0%{transform:translate(calc((-100vw + var(--wp--lightbox-scrollbar-width))/2 + var(--wp--lightbox-initial-left-position)),calc(-50vh + var(--wp--lightbox-initial-top-position))) scale(var(--wp--lightbox-scale))}to{transform:translate(-50%,-50%) scale(1)}}@keyframes lightbox-zoom-out{0%{transform:translate(-50%,-50%) scale(1);visibility:visible}99%{visibility:visible}to{transform:translate(calc((-100vw + var(--wp--lightbox-scrollbar-width))/2 + var(--wp--lightbox-initial-left-position)),calc(-50vh + var(--wp--lightbox-initial-top-position))) scale(var(--wp--lightbox-scale));visibility:hidden}}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/image/style.min.css */
		</style>
		<style id="wp-block-heading-inline-css">
			h1:where(.wp-block-heading).has-background,h2:where(.wp-block-heading).has-background,h3:where(.wp-block-heading).has-background,h4:where(.wp-block-heading).has-background,h5:where(.wp-block-heading).has-background,h6:where(.wp-block-heading).has-background{padding:1.25em 2.375em}h1.has-text-align-left[style*=writing-mode]:where([style*=vertical-lr]),h1.has-text-align-right[style*=writing-mode]:where([style*=vertical-rl]),h2.has-text-align-left[style*=writing-mode]:where([style*=vertical-lr]),h2.has-text-align-right[style*=writing-mode]:where([style*=vertical-rl]),h3.has-text-align-left[style*=writing-mode]:where([style*=vertical-lr]),h3.has-text-align-right[style*=writing-mode]:where([style*=vertical-rl]),h4.has-text-align-left[style*=writing-mode]:where([style*=vertical-lr]),h4.has-text-align-right[style*=writing-mode]:where([style*=vertical-rl]),h5.has-text-align-left[style*=writing-mode]:where([style*=vertical-lr]),h5.has-text-align-right[style*=writing-mode]:where([style*=vertical-rl]),h6.has-text-align-left[style*=writing-mode]:where([style*=vertical-lr]),h6.has-text-align-right[style*=writing-mode]:where([style*=vertical-rl]){rotate:180deg}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/heading/style.min.css */
		</style>
		<link rel="stylesheet" id="wp-block-cover-css" href="https://kerameikos.org/wp-includes/blocks/cover/style.min.css?ver=6.9.1" media="all"/>
		<style id="wp-block-spacer-inline-css">
			.wp-block-spacer {
			    clear: both
			}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/spacer/style.min.css */</style>
		<style id="wp-block-paragraph-inline-css">
			.is-small-text{font-size:.875em}.is-regular-text{font-size:1em}.is-large-text{font-size:2.25em}.is-larger-text{font-size:3em}.has-drop-cap:not(:focus):first-letter{float:left;font-size:8.4em;font-style:normal;font-weight:100;line-height:.68;margin:.05em .1em 0 0;text-transform:uppercase}body.rtl .has-drop-cap:not(:focus):first-letter{float:none;margin-left:.1em}p.has-drop-cap.has-background{overflow:hidden}:root :where(p.has-background){padding:1.25em 2.375em}:where(p.has-text-color:not(.has-link-color)) a{color:inherit}p.has-text-align-left[style*="writing-mode:vertical-lr"],p.has-text-align-right[style*="writing-mode:vertical-rl"]{rotate:180deg}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/paragraph/style.min.css */
		</style>
		<style id="wp-block-separator-inline-css">
			@charset "UTF-8";.wp-block-separator{border:none;border-top:2px solid}:root :where(.wp-block-separator.is-style-dots){height:auto;line-height:1;text-align:center}:root :where(.wp-block-separator.is-style-dots):before{color:currentColor;content:"···";font-family:serif;font-size:1.5em;letter-spacing:2em;padding-left:2em}.wp-block-separator.is-style-dots{background:none!important;border:none!important}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/separator/style.min.css */
		</style>
		<style id="wp-block-media-text-inline-css">
			.wp-block-media-text {
			    box-sizing: border-box;
			    /*!rtl:begin:ignore*/
			    direction: ltr;
			    /*!rtl:end:ignore*/
			    display: grid;
			    grid-template-columns: 50% 1fr;
			    grid-template-rows: auto
			}
			.wp-block-media-text.has-media-on-the-right {
			    grid-template-columns: 1fr 50%
			}
			.wp-block-media-text.is-vertically-aligned-top > .wp-block-media-text__content,
			.wp-block-media-text.is-vertically-aligned-top > .wp-block-media-text__media {
			    align-self: start
			}
			.wp-block-media-text.is-vertically-aligned-center > .wp-block-media-text__content,
			.wp-block-media-text.is-vertically-aligned-center > .wp-block-media-text__media,
			.wp-block-media-text > .wp-block-media-text__content,
			.wp-block-media-text > .wp-block-media-text__media {
			    align-self: center
			}
			.wp-block-media-text.is-vertically-aligned-bottom > .wp-block-media-text__content,
			.wp-block-media-text.is-vertically-aligned-bottom > .wp-block-media-text__media {
			    align-self: end
			}
			.wp-block-media-text > .wp-block-media-text__media {
			    /*!rtl:begin:ignore*/
			    grid-column: 1;
			    grid-row: 1;
			    /*!rtl:end:ignore*/
			    margin: 0
			}
			.wp-block-media-text > .wp-block-media-text__content {
			    direction: ltr;
			    /*!rtl:begin:ignore*/
			    grid-column: 2;
			    grid-row: 1;
			    /*!rtl:end:ignore*/
			    padding: 0 8%;
			    word-break: break-word
			}
			.wp-block-media-text.has-media-on-the-right > .wp-block-media-text__media {
			    /*!rtl:begin:ignore*/
			    grid-column: 2;
			    grid-row: 1
			    /*!rtl:end:ignore*/
			}
			.wp-block-media-text.has-media-on-the-right > .wp-block-media-text__content {
			    /*!rtl:begin:ignore*/
			    grid-column: 1;
			    grid-row: 1
			    /*!rtl:end:ignore*/
			}
			.wp-block-media-text__media a {
			    display: block
			}
			.wp-block-media-text__media img,
			.wp-block-media-text__media video {
			    height: auto;
			    max-width: unset;
			    vertical-align: middle;
			    width: 100%
			}
			.wp-block-media-text.is-image-fill > .wp-block-media-text__media {
			    background-size: cover;
			    height: 100%;
			    min-height: 250px
			}
			.wp-block-media-text.is-image-fill > .wp-block-media-text__media > a {
			    display: block;
			    height: 100%
			}
			.wp-block-media-text.is-image-fill > .wp-block-media-text__media img {
			    height: 1px;
			    margin: -1px;
			    overflow: hidden;
			    padding: 0;
			    position: absolute;
			    width: 1px;
			    clip: rect(0, 0, 0, 0);
			    border: 0
			}
			.wp-block-media-text.is-image-fill-element > .wp-block-media-text__media {
			    height: 100%;
			    min-height: 250px;
			    position: relative
			}
			.wp-block-media-text.is-image-fill-element > .wp-block-media-text__media > a {
			    display: block;
			    height: 100%
			}
			.wp-block-media-text.is-image-fill-element > .wp-block-media-text__media img {
			    height: 100%;
			    object-fit: cover;
			    position: absolute;
			    width: 100%
			}
			@media (max-width : 600px) {
			    .wp-block-media-text.is-stacked-on-mobile {
			        grid-template-columns: 100% !important
			    }
			    .wp-block-media-text.is-stacked-on-mobile > .wp-block-media-text__media {
			        grid-column: 1;
			        grid-row: 1
			    }
			    .wp-block-media-text.is-stacked-on-mobile > .wp-block-media-text__content {
			        grid-column: 1;
			        grid-row: 2
			    }
			}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/media-text/style.min.css */</style>
		<style id="wp-block-columns-inline-css">
			.wp-block-columns{box-sizing:border-box;display:flex;flex-wrap:wrap!important}@media (min-width:782px){.wp-block-columns{flex-wrap:nowrap!important}}.wp-block-columns{align-items:normal!important}.wp-block-columns.are-vertically-aligned-top{align-items:flex-start}.wp-block-columns.are-vertically-aligned-center{align-items:center}.wp-block-columns.are-vertically-aligned-bottom{align-items:flex-end}@media (max-width:781px){.wp-block-columns:not(.is-not-stacked-on-mobile)>.wp-block-column{flex-basis:100%!important}}@media (min-width:782px){.wp-block-columns:not(.is-not-stacked-on-mobile)>.wp-block-column{flex-basis:0;flex-grow:1}.wp-block-columns:not(.is-not-stacked-on-mobile)>.wp-block-column[style*=flex-basis]{flex-grow:0}}.wp-block-columns.is-not-stacked-on-mobile{flex-wrap:nowrap!important}.wp-block-columns.is-not-stacked-on-mobile>.wp-block-column{flex-basis:0;flex-grow:1}.wp-block-columns.is-not-stacked-on-mobile>.wp-block-column[style*=flex-basis]{flex-grow:0}:where(.wp-block-columns){margin-bottom:1.75em}:where(.wp-block-columns.has-background){padding:1.25em 2.375em}.wp-block-column{flex-grow:1;min-width:0;overflow-wrap:break-word;word-break:break-word}.wp-block-column.is-vertically-aligned-top{align-self:flex-start}.wp-block-column.is-vertically-aligned-center{align-self:center}.wp-block-column.is-vertically-aligned-bottom{align-self:flex-end}.wp-block-column.is-vertically-aligned-stretch{align-self:stretch}.wp-block-column.is-vertically-aligned-bottom,.wp-block-column.is-vertically-aligned-center,.wp-block-column.is-vertically-aligned-top{width:100%}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/columns/style.min.css */
		</style>
		<style id="wp-block-post-content-inline-css">
			.wp-block-post-content {
			    display: flow-root
			}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/post-content/style.min.css */</style>
		<style id="wp-block-social-links-inline-css">
			.wp-block-social-links{background:none;box-sizing:border-box;margin-left:0;padding-left:0;padding-right:0;text-indent:0}.wp-block-social-links .wp-social-link a,.wp-block-social-links .wp-social-link a:hover{border-bottom:0;box-shadow:none;text-decoration:none}.wp-block-social-links .wp-social-link svg{height:1em;width:1em}.wp-block-social-links .wp-social-link span:not(.screen-reader-text){font-size:.65em;margin-left:.5em;margin-right:.5em}.wp-block-social-links.has-small-icon-size{font-size:16px}.wp-block-social-links,.wp-block-social-links.has-normal-icon-size{font-size:24px}.wp-block-social-links.has-large-icon-size{font-size:36px}.wp-block-social-links.has-huge-icon-size{font-size:48px}.wp-block-social-links.aligncenter{display:flex;justify-content:center}.wp-block-social-links.alignright{justify-content:flex-end}.wp-block-social-link{border-radius:9999px;display:block}@media not (prefers-reduced-motion){.wp-block-social-link{transition:transform .1s ease}}.wp-block-social-link{height:auto}.wp-block-social-link a{align-items:center;display:flex;line-height:0}.wp-block-social-link:hover{transform:scale(1.1)}.wp-block-social-links .wp-block-social-link.wp-social-link{display:inline-block;margin:0;padding:0}.wp-block-social-links .wp-block-social-link.wp-social-link .wp-block-social-link-anchor,.wp-block-social-links .wp-block-social-link.wp-social-link .wp-block-social-link-anchor svg,.wp-block-social-links .wp-block-social-link.wp-social-link .wp-block-social-link-anchor:active,.wp-block-social-links .wp-block-social-link.wp-social-link .wp-block-social-link-anchor:hover,.wp-block-social-links .wp-block-social-link.wp-social-link .wp-block-social-link-anchor:visited{color:currentColor;fill:currentColor}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link{background-color:#f0f0f0;color:#444}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-amazon{background-color:#f90;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-bandcamp{background-color:#1ea0c3;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-behance{background-color:#0757fe;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-bluesky{background-color:#0a7aff;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-codepen{background-color:#1e1f26;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-deviantart{background-color:#02e49b;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-discord{background-color:#5865f2;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-dribbble{background-color:#e94c89;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-dropbox{background-color:#4280ff;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-etsy{background-color:#f45800;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-facebook{background-color:#0866ff;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-fivehundredpx{background-color:#000;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-flickr{background-color:#0461dd;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-foursquare{background-color:#e65678;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-github{background-color:#24292d;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-goodreads{background-color:#eceadd;color:#382110}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-google{background-color:#ea4434;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-gravatar{background-color:#1d4fc4;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-instagram{background-color:#f00075;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-lastfm{background-color:#e21b24;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-linkedin{background-color:#0d66c2;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-mastodon{background-color:#3288d4;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-medium{background-color:#000;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-meetup{background-color:#f6405f;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-patreon{background-color:#000;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-pinterest{background-color:#e60122;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-pocket{background-color:#ef4155;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-reddit{background-color:#ff4500;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-skype{background-color:#0478d7;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-snapchat{background-color:#fefc00;color:#fff;stroke:#000}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-soundcloud{background-color:#ff5600;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-spotify{background-color:#1bd760;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-telegram{background-color:#2aabee;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-threads{background-color:#000;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-tiktok{background-color:#000;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-tumblr{background-color:#011835;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-twitch{background-color:#6440a4;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-twitter{background-color:#1da1f2;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-vimeo{background-color:#1eb7ea;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-vk{background-color:#4680c2;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-wordpress{background-color:#3499cd;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-whatsapp{background-color:#25d366;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-x{background-color:#000;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-yelp{background-color:#d32422;color:#fff}:where(.wp-block-social-links:not(.is-style-logos-only)) .wp-social-link-youtube{background-color:red;color:#fff}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link{background:none}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link svg{height:1.25em;width:1.25em}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-amazon{color:#f90}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-bandcamp{color:#1ea0c3}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-behance{color:#0757fe}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-bluesky{color:#0a7aff}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-codepen{color:#1e1f26}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-deviantart{color:#02e49b}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-discord{color:#5865f2}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-dribbble{color:#e94c89}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-dropbox{color:#4280ff}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-etsy{color:#f45800}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-facebook{color:#0866ff}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-fivehundredpx{color:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-flickr{color:#0461dd}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-foursquare{color:#e65678}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-github{color:#24292d}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-goodreads{color:#382110}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-google{color:#ea4434}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-gravatar{color:#1d4fc4}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-instagram{color:#f00075}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-lastfm{color:#e21b24}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-linkedin{color:#0d66c2}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-mastodon{color:#3288d4}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-medium{color:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-meetup{color:#f6405f}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-patreon{color:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-pinterest{color:#e60122}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-pocket{color:#ef4155}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-reddit{color:#ff4500}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-skype{color:#0478d7}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-snapchat{color:#fff;stroke:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-soundcloud{color:#ff5600}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-spotify{color:#1bd760}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-telegram{color:#2aabee}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-threads{color:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-tiktok{color:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-tumblr{color:#011835}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-twitch{color:#6440a4}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-twitter{color:#1da1f2}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-vimeo{color:#1eb7ea}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-vk{color:#4680c2}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-whatsapp{color:#25d366}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-wordpress{color:#3499cd}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-x{color:#000}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-yelp{color:#d32422}:where(.wp-block-social-links.is-style-logos-only) .wp-social-link-youtube{color:red}.wp-block-social-links.is-style-pill-shape .wp-social-link{width:auto}:root :where(.wp-block-social-links .wp-social-link a){padding:.25em}:root :where(.wp-block-social-links.is-style-logos-only .wp-social-link a){padding:0}:root :where(.wp-block-social-links.is-style-pill-shape .wp-social-link a){padding-left:.6666666667em;padding-right:.6666666667em}.wp-block-social-links:not(.has-icon-color):not(.has-icon-background-color) .wp-social-link-snapchat .wp-block-social-link-label{color:#000}
			/*# sourceURL=https://kerameikos.org/wp-includes/blocks/social-links/style.min.css */
		</style>
		<style id="wp-emoji-styles-inline-css">
			img.wp-smiley,
			img.emoji {
			    display: inline !important;
			    border: none !important;
			    box-shadow: none !important;
			    height: 1em !important;
			    width: 1em !important;
			    margin: 0 0.07em !important;
			    vertical-align: -0.1em !important;
			    background: none !important;
			    padding: 0 !important;
			}
			/*# sourceURL=wp-emoji-styles-inline-css */</style>
		<style id="wp-block-library-inline-css">
			:root{--wp-block-synced-color:#7a00df;--wp-block-synced-color--rgb:122,0,223;--wp-bound-block-color:var(--wp-block-synced-color);--wp-editor-canvas-background:#ddd;--wp-admin-theme-color:#007cba;--wp-admin-theme-color--rgb:0,124,186;--wp-admin-theme-color-darker-10:#006ba1;--wp-admin-theme-color-darker-10--rgb:0,107,160.5;--wp-admin-theme-color-darker-20:#005a87;--wp-admin-theme-color-darker-20--rgb:0,90,135;--wp-admin-border-width-focus:2px}@media (min-resolution:192dpi){:root{--wp-admin-border-width-focus:1.5px}}.wp-element-button{cursor:pointer}:root .has-very-light-gray-background-color{background-color:#eee}:root .has-very-dark-gray-background-color{background-color:#313131}:root .has-very-light-gray-color{color:#eee}:root .has-very-dark-gray-color{color:#313131}:root .has-vivid-green-cyan-to-vivid-cyan-blue-gradient-background{background:linear-gradient(135deg,#00d084,#0693e3)}:root .has-purple-crush-gradient-background{background:linear-gradient(135deg,#34e2e4,#4721fb 50%,#ab1dfe)}:root .has-hazy-dawn-gradient-background{background:linear-gradient(135deg,#faaca8,#dad0ec)}:root .has-subdued-olive-gradient-background{background:linear-gradient(135deg,#fafae1,#67a671)}:root .has-atomic-cream-gradient-background{background:linear-gradient(135deg,#fdd79a,#004a59)}:root .has-nightshade-gradient-background{background:linear-gradient(135deg,#330968,#31cdcf)}:root .has-midnight-gradient-background{background:linear-gradient(135deg,#020381,#2874fc)}:root{--wp--preset--font-size--normal:16px;--wp--preset--font-size--huge:42px}.has-regular-font-size{font-size:1em}.has-larger-font-size{font-size:2.625em}.has-normal-font-size{font-size:var(--wp--preset--font-size--normal)}.has-huge-font-size{font-size:var(--wp--preset--font-size--huge)}.has-text-align-center{text-align:center}.has-text-align-left{text-align:left}.has-text-align-right{text-align:right}.has-fit-text{white-space:nowrap!important}#end-resizable-editor-section{display:none}.aligncenter{clear:both}.items-justified-left{justify-content:flex-start}.items-justified-center{justify-content:center}.items-justified-right{justify-content:flex-end}.items-justified-space-between{justify-content:space-between}.screen-reader-text{border:0;clip-path:inset(50%);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;word-wrap:normal!important}.screen-reader-text:focus{background-color:#ddd;clip-path:none;color:#444;display:block;font-size:1em;height:auto;left:5px;line-height:normal;padding:15px 23px 14px;text-decoration:none;top:5px;width:auto;z-index:100000}html :where(.has-border-color){border-style:solid}html :where([style*=border-top-color]){border-top-style:solid}html :where([style*=border-right-color]){border-right-style:solid}html :where([style*=border-bottom-color]){border-bottom-style:solid}html :where([style*=border-left-color]){border-left-style:solid}html :where([style*=border-width]){border-style:solid}html :where([style*=border-top-width]){border-top-style:solid}html :where([style*=border-right-width]){border-right-style:solid}html :where([style*=border-bottom-width]){border-bottom-style:solid}html :where([style*=border-left-width]){border-left-style:solid}html :where(img[class*=wp-image-]){height:auto;max-width:100%}:where(figure){margin:0 0 1em}html :where(.is-position-sticky){--wp-admin--admin-bar--position-offset:var(--wp-admin--admin-bar--height,0px)}@media screen and (max-width:600px){html :where(.is-position-sticky){--wp-admin--admin-bar--position-offset:0px}}
			/*# sourceURL=/wp-includes/css/dist/block-library/common.min.css */
		</style>
		<style id="global-styles-inline-css">
			:root{--wp--preset--aspect-ratio--square: 1;--wp--preset--aspect-ratio--4-3: 4/3;--wp--preset--aspect-ratio--3-4: 3/4;--wp--preset--aspect-ratio--3-2: 3/2;--wp--preset--aspect-ratio--2-3: 2/3;--wp--preset--aspect-ratio--16-9: 16/9;--wp--preset--aspect-ratio--9-16: 9/16;--wp--preset--color--black: #000000;--wp--preset--color--cyan-bluish-gray: #abb8c3;--wp--preset--color--white: #ffffff;--wp--preset--color--pale-pink: #f78da7;--wp--preset--color--vivid-red: #cf2e2e;--wp--preset--color--luminous-vivid-orange: #ff6900;--wp--preset--color--luminous-vivid-amber: #fcb900;--wp--preset--color--light-green-cyan: #7bdcb5;--wp--preset--color--vivid-green-cyan: #00d084;--wp--preset--color--pale-cyan-blue: #8ed1fc;--wp--preset--color--vivid-cyan-blue: #0693e3;--wp--preset--color--vivid-purple: #9b51e0;--wp--preset--color--base: #FFFFFF;--wp--preset--color--contrast: #111111;--wp--preset--color--accent-1: #FFEE58;--wp--preset--color--accent-2: #F6CFF4;--wp--preset--color--accent-3: #503AA8;--wp--preset--color--accent-4: #686868;--wp--preset--color--accent-5: #FBFAF3;--wp--preset--color--accent-6: color-mix(in srgb, currentColor 20%, transparent);--wp--preset--color--custom-baltic: #1d1c22;--wp--preset--color--custom-basalt: #3e3b47;--wp--preset--color--custom-dolphin: #6c697d;--wp--preset--color--custom-meteora: #c76a14;--wp--preset--color--custom-jaffa: #ed9749;--wp--preset--color--custom-mercury: #ebe6e5;--wp--preset--color--custom-gull: #a6a4b2;--wp--preset--gradient--vivid-cyan-blue-to-vivid-purple: linear-gradient(135deg,rgb(6,147,227) 0%,rgb(155,81,224) 100%);--wp--preset--gradient--light-green-cyan-to-vivid-green-cyan: linear-gradient(135deg,rgb(122,220,180) 0%,rgb(0,208,130) 100%);--wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange: linear-gradient(135deg,rgb(252,185,0) 0%,rgb(255,105,0) 100%);--wp--preset--gradient--luminous-vivid-orange-to-vivid-red: linear-gradient(135deg,rgb(255,105,0) 0%,rgb(207,46,46) 100%);--wp--preset--gradient--very-light-gray-to-cyan-bluish-gray: linear-gradient(135deg,rgb(238,238,238) 0%,rgb(169,184,195) 100%);--wp--preset--gradient--cool-to-warm-spectrum: linear-gradient(135deg,rgb(74,234,220) 0%,rgb(151,120,209) 20%,rgb(207,42,186) 40%,rgb(238,44,130) 60%,rgb(251,105,98) 80%,rgb(254,248,76) 100%);--wp--preset--gradient--blush-light-purple: linear-gradient(135deg,rgb(255,206,236) 0%,rgb(152,150,240) 100%);--wp--preset--gradient--blush-bordeaux: linear-gradient(135deg,rgb(254,205,165) 0%,rgb(254,45,45) 50%,rgb(107,0,62) 100%);--wp--preset--gradient--luminous-dusk: linear-gradient(135deg,rgb(255,203,112) 0%,rgb(199,81,192) 50%,rgb(65,88,208) 100%);--wp--preset--gradient--pale-ocean: linear-gradient(135deg,rgb(255,245,203) 0%,rgb(182,227,212) 50%,rgb(51,167,181) 100%);--wp--preset--gradient--electric-grass: linear-gradient(135deg,rgb(202,248,128) 0%,rgb(113,206,126) 100%);--wp--preset--gradient--midnight: linear-gradient(135deg,rgb(2,3,129) 0%,rgb(40,116,252) 100%);--wp--preset--font-size--small: 0.875rem;--wp--preset--font-size--medium: clamp(1rem, 1rem + ((1vw - 0.2rem) * 0.196), 1.125rem);--wp--preset--font-size--large: clamp(1.125rem, 1.125rem + ((1vw - 0.2rem) * 0.392), 1.375rem);--wp--preset--font-size--x-large: clamp(1.75rem, 1.75rem + ((1vw - 0.2rem) * 0.392), 2rem);--wp--preset--font-size--xx-large: clamp(2.15rem, 2.15rem + ((1vw - 0.2rem) * 1.333), 3rem);--wp--preset--font-family--manrope: Manrope, sans-serif;--wp--preset--font-family--fira-code: "Fira Code", monospace;--wp--preset--spacing--20: 10px;--wp--preset--spacing--30: 20px;--wp--preset--spacing--40: 30px;--wp--preset--spacing--50: clamp(30px, 5vw, 50px);--wp--preset--spacing--60: clamp(30px, 7vw, 70px);--wp--preset--spacing--70: clamp(50px, 7vw, 90px);--wp--preset--spacing--80: clamp(70px, 10vw, 140px);--wp--preset--shadow--natural: 6px 6px 9px rgba(0, 0, 0, 0.2);--wp--preset--shadow--deep: 12px 12px 50px rgba(0, 0, 0, 0.4);--wp--preset--shadow--sharp: 6px 6px 0px rgba(0, 0, 0, 0.2);--wp--preset--shadow--outlined: 6px 6px 0px -3px rgb(255, 255, 255), 6px 6px rgb(0, 0, 0);--wp--preset--shadow--crisp: 6px 6px 0px rgb(0, 0, 0);}:root { --wp--style--global--content-size: 645px;--wp--style--global--wide-size: 1340px; }:where(body) { margin: 0; }.wp-site-blocks { padding-top: var(--wp--style--root--padding-top); padding-bottom: var(--wp--style--root--padding-bottom); }.has-global-padding { padding-right: var(--wp--style--root--padding-right); padding-left: var(--wp--style--root--padding-left); }.has-global-padding > .alignfull { margin-right: calc(var(--wp--style--root--padding-right) * -1); margin-left: calc(var(--wp--style--root--padding-left) * -1); }.has-global-padding :where(:not(.alignfull.is-layout-flow) > .has-global-padding:not(.wp-block-block, .alignfull)) { padding-right: 0; padding-left: 0; }.has-global-padding :where(:not(.alignfull.is-layout-flow) > .has-global-padding:not(.wp-block-block, .alignfull)) > .alignfull { margin-left: 0; margin-right: 0; }.wp-site-blocks > .alignleft { float: left; margin-right: 2em; }.wp-site-blocks > .alignright { float: right; margin-left: 2em; }.wp-site-blocks > .aligncenter { justify-content: center; margin-left: auto; margin-right: auto; }:where(.wp-site-blocks) > * { margin-block-start: 1.2rem; margin-block-end: 0; }:where(.wp-site-blocks) > :first-child { margin-block-start: 0; }:where(.wp-site-blocks) > :last-child { margin-block-end: 0; }:root { --wp--style--block-gap: 1.2rem; }:root :where(.is-layout-flow) > :first-child{margin-block-start: 0;}:root :where(.is-layout-flow) > :last-child{margin-block-end: 0;}:root :where(.is-layout-flow) > *{margin-block-start: 1.2rem;margin-block-end: 0;}:root :where(.is-layout-constrained) > :first-child{margin-block-start: 0;}:root :where(.is-layout-constrained) > :last-child{margin-block-end: 0;}:root :where(.is-layout-constrained) > *{margin-block-start: 1.2rem;margin-block-end: 0;}:root :where(.is-layout-flex){gap: 1.2rem;}:root :where(.is-layout-grid){gap: 1.2rem;}.is-layout-flow > .alignleft{float: left;margin-inline-start: 0;margin-inline-end: 2em;}.is-layout-flow > .alignright{float: right;margin-inline-start: 2em;margin-inline-end: 0;}.is-layout-flow > .aligncenter{margin-left: auto !important;margin-right: auto !important;}.is-layout-constrained > .alignleft{float: left;margin-inline-start: 0;margin-inline-end: 2em;}.is-layout-constrained > .alignright{float: right;margin-inline-start: 2em;margin-inline-end: 0;}.is-layout-constrained > .aligncenter{margin-left: auto !important;margin-right: auto !important;}.is-layout-constrained > :where(:not(.alignleft):not(.alignright):not(.alignfull)){max-width: var(--wp--style--global--content-size);margin-left: auto !important;margin-right: auto !important;}.is-layout-constrained > .alignwide{max-width: var(--wp--style--global--wide-size);}body .is-layout-flex{display: flex;}.is-layout-flex{flex-wrap: wrap;align-items: center;}.is-layout-flex > :is(*, div){margin: 0;}body .is-layout-grid{display: grid;}.is-layout-grid > :is(*, div){margin: 0;}body{background-color: var(--wp--preset--color--base);color: var(--wp--preset--color--contrast);font-family: var(--wp--preset--font-family--manrope);font-size: var(--wp--preset--font-size--large);font-weight: 300;letter-spacing: -0.1px;line-height: 1.4;--wp--style--root--padding-top: 0px;--wp--style--root--padding-right: var(--wp--preset--spacing--50);--wp--style--root--padding-bottom: 0px;--wp--style--root--padding-left: var(--wp--preset--spacing--50);}a:where(:not(.wp-element-button)){color: currentColor;text-decoration: underline;}:root :where(a:where(:not(.wp-element-button)):hover){text-decoration: none;}h1, h2, h3, h4, h5, h6{font-weight: 400;letter-spacing: -0.1px;line-height: 1.125;}h1{font-size: var(--wp--preset--font-size--xx-large);}h2{font-size: var(--wp--preset--font-size--x-large);}h3{font-size: var(--wp--preset--font-size--large);}h4{font-size: var(--wp--preset--font-size--medium);}h5{font-size: var(--wp--preset--font-size--small);letter-spacing: 0.5px;}h6{font-size: var(--wp--preset--font-size--small);font-weight: 700;letter-spacing: 1.4px;text-transform: uppercase;}:root :where(.wp-element-button, .wp-block-button__link){background-color: var(--wp--preset--color--contrast);border-width: 0;color: var(--wp--preset--color--base);font-family: inherit;font-size: var(--wp--preset--font-size--medium);font-style: inherit;font-weight: inherit;letter-spacing: inherit;line-height: inherit;padding-top: 1rem;padding-right: 2.25rem;padding-bottom: 1rem;padding-left: 2.25rem;text-decoration: none;text-transform: inherit;}:root :where(.wp-element-button:hover, .wp-block-button__link:hover){background-color: color-mix(in srgb, var(--wp--preset--color--contrast) 85%, transparent);border-color: transparent;color: var(--wp--preset--color--base);}:root :where(.wp-element-button:focus, .wp-block-button__link:focus){outline-color: var(--wp--preset--color--accent-4);outline-offset: 2px;}:root :where(.wp-element-caption, .wp-block-audio figcaption, .wp-block-embed figcaption, .wp-block-gallery figcaption, .wp-block-image figcaption, .wp-block-table figcaption, .wp-block-video figcaption){font-size: var(--wp--preset--font-size--small);line-height: 1.4;}.has-black-color{color: var(--wp--preset--color--black) !important;}.has-cyan-bluish-gray-color{color: var(--wp--preset--color--cyan-bluish-gray) !important;}.has-white-color{color: var(--wp--preset--color--white) !important;}.has-pale-pink-color{color: var(--wp--preset--color--pale-pink) !important;}.has-vivid-red-color{color: var(--wp--preset--color--vivid-red) !important;}.has-luminous-vivid-orange-color{color: var(--wp--preset--color--luminous-vivid-orange) !important;}.has-luminous-vivid-amber-color{color: var(--wp--preset--color--luminous-vivid-amber) !important;}.has-light-green-cyan-color{color: var(--wp--preset--color--light-green-cyan) !important;}.has-vivid-green-cyan-color{color: var(--wp--preset--color--vivid-green-cyan) !important;}.has-pale-cyan-blue-color{color: var(--wp--preset--color--pale-cyan-blue) !important;}.has-vivid-cyan-blue-color{color: var(--wp--preset--color--vivid-cyan-blue) !important;}.has-vivid-purple-color{color: var(--wp--preset--color--vivid-purple) !important;}.has-base-color{color: var(--wp--preset--color--base) !important;}.has-contrast-color{color: var(--wp--preset--color--contrast) !important;}.has-accent-1-color{color: var(--wp--preset--color--accent-1) !important;}.has-accent-2-color{color: var(--wp--preset--color--accent-2) !important;}.has-accent-3-color{color: var(--wp--preset--color--accent-3) !important;}.has-accent-4-color{color: var(--wp--preset--color--accent-4) !important;}.has-accent-5-color{color: var(--wp--preset--color--accent-5) !important;}.has-accent-6-color{color: var(--wp--preset--color--accent-6) !important;}.has-custom-baltic-color{color: var(--wp--preset--color--custom-baltic) !important;}.has-custom-basalt-color{color: var(--wp--preset--color--custom-basalt) !important;}.has-custom-dolphin-color{color: var(--wp--preset--color--custom-dolphin) !important;}.has-custom-meteora-color{color: var(--wp--preset--color--custom-meteora) !important;}.has-custom-jaffa-color{color: var(--wp--preset--color--custom-jaffa) !important;}.has-custom-mercury-color{color: var(--wp--preset--color--custom-mercury) !important;}.has-custom-gull-color{color: var(--wp--preset--color--custom-gull) !important;}.has-black-background-color{background-color: var(--wp--preset--color--black) !important;}.has-cyan-bluish-gray-background-color{background-color: var(--wp--preset--color--cyan-bluish-gray) !important;}.has-white-background-color{background-color: var(--wp--preset--color--white) !important;}.has-pale-pink-background-color{background-color: var(--wp--preset--color--pale-pink) !important;}.has-vivid-red-background-color{background-color: var(--wp--preset--color--vivid-red) !important;}.has-luminous-vivid-orange-background-color{background-color: var(--wp--preset--color--luminous-vivid-orange) !important;}.has-luminous-vivid-amber-background-color{background-color: var(--wp--preset--color--luminous-vivid-amber) !important;}.has-light-green-cyan-background-color{background-color: var(--wp--preset--color--light-green-cyan) !important;}.has-vivid-green-cyan-background-color{background-color: var(--wp--preset--color--vivid-green-cyan) !important;}.has-pale-cyan-blue-background-color{background-color: var(--wp--preset--color--pale-cyan-blue) !important;}.has-vivid-cyan-blue-background-color{background-color: var(--wp--preset--color--vivid-cyan-blue) !important;}.has-vivid-purple-background-color{background-color: var(--wp--preset--color--vivid-purple) !important;}.has-base-background-color{background-color: var(--wp--preset--color--base) !important;}.has-contrast-background-color{background-color: var(--wp--preset--color--contrast) !important;}.has-accent-1-background-color{background-color: var(--wp--preset--color--accent-1) !important;}.has-accent-2-background-color{background-color: var(--wp--preset--color--accent-2) !important;}.has-accent-3-background-color{background-color: var(--wp--preset--color--accent-3) !important;}.has-accent-4-background-color{background-color: var(--wp--preset--color--accent-4) !important;}.has-accent-5-background-color{background-color: var(--wp--preset--color--accent-5) !important;}.has-accent-6-background-color{background-color: var(--wp--preset--color--accent-6) !important;}.has-custom-baltic-background-color{background-color: var(--wp--preset--color--custom-baltic) !important;}.has-custom-basalt-background-color{background-color: var(--wp--preset--color--custom-basalt) !important;}.has-custom-dolphin-background-color{background-color: var(--wp--preset--color--custom-dolphin) !important;}.has-custom-meteora-background-color{background-color: var(--wp--preset--color--custom-meteora) !important;}.has-custom-jaffa-background-color{background-color: var(--wp--preset--color--custom-jaffa) !important;}.has-custom-mercury-background-color{background-color: var(--wp--preset--color--custom-mercury) !important;}.has-custom-gull-background-color{background-color: var(--wp--preset--color--custom-gull) !important;}.has-black-border-color{border-color: var(--wp--preset--color--black) !important;}.has-cyan-bluish-gray-border-color{border-color: var(--wp--preset--color--cyan-bluish-gray) !important;}.has-white-border-color{border-color: var(--wp--preset--color--white) !important;}.has-pale-pink-border-color{border-color: var(--wp--preset--color--pale-pink) !important;}.has-vivid-red-border-color{border-color: var(--wp--preset--color--vivid-red) !important;}.has-luminous-vivid-orange-border-color{border-color: var(--wp--preset--color--luminous-vivid-orange) !important;}.has-luminous-vivid-amber-border-color{border-color: var(--wp--preset--color--luminous-vivid-amber) !important;}.has-light-green-cyan-border-color{border-color: var(--wp--preset--color--light-green-cyan) !important;}.has-vivid-green-cyan-border-color{border-color: var(--wp--preset--color--vivid-green-cyan) !important;}.has-pale-cyan-blue-border-color{border-color: var(--wp--preset--color--pale-cyan-blue) !important;}.has-vivid-cyan-blue-border-color{border-color: var(--wp--preset--color--vivid-cyan-blue) !important;}.has-vivid-purple-border-color{border-color: var(--wp--preset--color--vivid-purple) !important;}.has-base-border-color{border-color: var(--wp--preset--color--base) !important;}.has-contrast-border-color{border-color: var(--wp--preset--color--contrast) !important;}.has-accent-1-border-color{border-color: var(--wp--preset--color--accent-1) !important;}.has-accent-2-border-color{border-color: var(--wp--preset--color--accent-2) !important;}.has-accent-3-border-color{border-color: var(--wp--preset--color--accent-3) !important;}.has-accent-4-border-color{border-color: var(--wp--preset--color--accent-4) !important;}.has-accent-5-border-color{border-color: var(--wp--preset--color--accent-5) !important;}.has-accent-6-border-color{border-color: var(--wp--preset--color--accent-6) !important;}.has-custom-baltic-border-color{border-color: var(--wp--preset--color--custom-baltic) !important;}.has-custom-basalt-border-color{border-color: var(--wp--preset--color--custom-basalt) !important;}.has-custom-dolphin-border-color{border-color: var(--wp--preset--color--custom-dolphin) !important;}.has-custom-meteora-border-color{border-color: var(--wp--preset--color--custom-meteora) !important;}.has-custom-jaffa-border-color{border-color: var(--wp--preset--color--custom-jaffa) !important;}.has-custom-mercury-border-color{border-color: var(--wp--preset--color--custom-mercury) !important;}.has-custom-gull-border-color{border-color: var(--wp--preset--color--custom-gull) !important;}.has-vivid-cyan-blue-to-vivid-purple-gradient-background{background: var(--wp--preset--gradient--vivid-cyan-blue-to-vivid-purple) !important;}.has-light-green-cyan-to-vivid-green-cyan-gradient-background{background: var(--wp--preset--gradient--light-green-cyan-to-vivid-green-cyan) !important;}.has-luminous-vivid-amber-to-luminous-vivid-orange-gradient-background{background: var(--wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange) !important;}.has-luminous-vivid-orange-to-vivid-red-gradient-background{background: var(--wp--preset--gradient--luminous-vivid-orange-to-vivid-red) !important;}.has-very-light-gray-to-cyan-bluish-gray-gradient-background{background: var(--wp--preset--gradient--very-light-gray-to-cyan-bluish-gray) !important;}.has-cool-to-warm-spectrum-gradient-background{background: var(--wp--preset--gradient--cool-to-warm-spectrum) !important;}.has-blush-light-purple-gradient-background{background: var(--wp--preset--gradient--blush-light-purple) !important;}.has-blush-bordeaux-gradient-background{background: var(--wp--preset--gradient--blush-bordeaux) !important;}.has-luminous-dusk-gradient-background{background: var(--wp--preset--gradient--luminous-dusk) !important;}.has-pale-ocean-gradient-background{background: var(--wp--preset--gradient--pale-ocean) !important;}.has-electric-grass-gradient-background{background: var(--wp--preset--gradient--electric-grass) !important;}.has-midnight-gradient-background{background: var(--wp--preset--gradient--midnight) !important;}.has-small-font-size{font-size: var(--wp--preset--font-size--small) !important;}.has-medium-font-size{font-size: var(--wp--preset--font-size--medium) !important;}.has-large-font-size{font-size: var(--wp--preset--font-size--large) !important;}.has-x-large-font-size{font-size: var(--wp--preset--font-size--x-large) !important;}.has-xx-large-font-size{font-size: var(--wp--preset--font-size--xx-large) !important;}.has-manrope-font-family{font-family: var(--wp--preset--font-family--manrope) !important;}.has-fira-code-font-family{font-family: var(--wp--preset--font-family--fira-code) !important;}
			:root :where(.wp-block-columns-is-layout-flow) > :first-child{margin-block-start: 0;}:root :where(.wp-block-columns-is-layout-flow) > :last-child{margin-block-end: 0;}:root :where(.wp-block-columns-is-layout-flow) > *{margin-block-start: var(--wp--preset--spacing--50);margin-block-end: 0;}:root :where(.wp-block-columns-is-layout-constrained) > :first-child{margin-block-start: 0;}:root :where(.wp-block-columns-is-layout-constrained) > :last-child{margin-block-end: 0;}:root :where(.wp-block-columns-is-layout-constrained) > *{margin-block-start: var(--wp--preset--spacing--50);margin-block-end: 0;}:root :where(.wp-block-columns-is-layout-flex){gap: var(--wp--preset--spacing--50);}:root :where(.wp-block-columns-is-layout-grid){gap: var(--wp--preset--spacing--50);}
			:root :where(.wp-block-separator){border-color: currentColor;border-width: 0 0 1px 0;border-style: solid;color: var(--wp--preset--color--accent-6);}
			:root :where(.wp-block-site-title){font-weight: 700;letter-spacing: -.5px;}
			:root :where(.wp-block-site-title a:where(:not(.wp-element-button))){text-decoration: none;}
			:root :where(.wp-block-site-title a:where(:not(.wp-element-button)):hover){text-decoration: underline;}
			:root :where(.wp-block-navigation){font-size: var(--wp--preset--font-size--medium);}
			:root :where(.wp-block-navigation a:where(:not(.wp-element-button))){text-decoration: none;}
			:root :where(.wp-block-navigation a:where(:not(.wp-element-button)):hover){text-decoration: underline;}
			/*# sourceURL=global-styles-inline-css */
		</style>
		<style id="core-block-supports-inline-css">
			.wp-elements-05d43b6fd045381f4e5b4258cb5dfd2c a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-eggshell);}.wp-elements-96bba6e487e230c38aa87bfb36176316 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--base);}.wp-elements-2465b3b57bdb399e093928f6e7c43f21 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-pearl);}.wp-elements-2e19baad4cc787ca0f3b34e82b7a7aa3 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--base);}.wp-elements-63170f6cfc92695cd7d38d2317310ce1 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-pearl);}.wp-container-core-navigation-is-layout-64619e5e{justify-content:flex-end;}.wp-container-core-group-is-layout-78c6040a{flex-wrap:nowrap;gap:0;justify-content:space-between;}.wp-container-core-group-is-layout-ddaf840a > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-ddaf840a > * + *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-19e250f3 > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-19e250f3 > * + *{margin-block-start:0;margin-block-end:0;}.wp-elements-6f0615fe74493bdc669a03eafc503c0b a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-meteora);}.wp-elements-ecc60ad3edbb8e9dc384805035a7bac7 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-meteora);}.wp-elements-a43d95db02c8f1ec9935e757ca7adb5c a:where(:not(.wp-element-button)){color:var(--wp--preset--color--contrast);}.wp-elements-cc2120538df8817001d04c4aafe74b40 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-group-is-layout-80f0afbe > .alignfull{margin-left:calc(var(--wp--preset--spacing--40) * -1);}.wp-container-core-group-is-layout-80f0afbe > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-80f0afbe > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-container-core-group-is-layout-e0082cf6 > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-e0082cf6 > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-elements-a635b1760be427844b24734ae16b826f a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-group-is-layout-3e11c9cf > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-3e11c9cf > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-elements-5f1fdcb9f5e433620c079850536c7048 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-group-is-layout-a04c59d8 > .alignfull{margin-right:calc(var(--wp--preset--spacing--50) * -1);margin-left:calc(var(--wp--preset--spacing--50) * -1);}.wp-elements-df48e36f0162f783367443d1d769648c a:where(:not(.wp-element-button)){color:var(--wp--preset--color--contrast);}.wp-elements-5bcd68fda5722d3c5f1a8c9c3b9a988c a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-group-is-layout-5bf6180f > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-5bf6180f > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-container-core-group-is-layout-868be0f1 > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-868be0f1 > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-elements-9c92c652b528fd084a21e92a1716460d a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-61d8bf148bb5bae390a9351bab88cdc9 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-dfcf21253da4b0d9dad4f82b187c2401 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-group-is-layout-f881c761 > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-f881c761 > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-container-core-column-is-layout-b108c007 > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-column-is-layout-b108c007 > * + *{margin-block-start:0;margin-block-end:0;}.wp-elements-2020cde4f0c3b6ab9589ee8e8b022da7 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-ff98aba8c9ecd70c750f0555bf70857a a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-bd566f38be8e2416bb31c67874d339ad a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-group-is-layout-aa991783 > *{margin-block-start:0;margin-block-end:0;}.wp-container-core-group-is-layout-aa991783 > * + *{margin-block-start:var(--wp--preset--spacing--20);margin-block-end:0;}.wp-elements-f6efb8bed09e14620c856999cc7bb45e a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-container-core-columns-is-layout-28f84493{flex-wrap:nowrap;}.wp-container-core-group-is-layout-ae002d71 > .alignfull{margin-right:calc(var(--wp--preset--spacing--50) * -1);margin-left:calc(var(--wp--preset--spacing--50) * -1);}.wp-elements-bbbccf8507cd0eb04443083c006572aa a:where(:not(.wp-element-button)){color:var(--wp--preset--color--contrast);}.wp-elements-13b0cb13c4d8512ef33cb6944788285e a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-39049e68f1fcdc79a50d3edf5dd1a18f a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-7225f435977efd50cf8cf84ba0a246b8 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-04115e1064429b212388ba8e86261caf a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-282b51b6c3f1738cfc2b942f142d1070 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--contrast);}.wp-elements-d5100010bbc87a43e4e34f2f044db8c8 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-d4a7a7ecc8d9107736152b809348dce7 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-352749e55be2fdcab13aaa5490f9b272 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-55e05c7ecd36b365636cc418c63b32ee a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-dolphin);}.wp-elements-c274abde050f7aac1c729484c8424fe2 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--custom-eggshell);}.wp-container-content-b0223bd5{flex-basis:25%;}.wp-elements-53866209a0a6fcae0356d149a44ff039 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--base);}.wp-container-core-social-links-is-layout-845a9879{gap:0 12px;justify-content:center;}.wp-container-core-group-is-layout-3d16a5d4{flex-direction:column;align-items:center;justify-content:flex-start;}.wp-elements-b6cd64af30ee757b05b6f212daaaffa6 a:where(:not(.wp-element-button)){color:var(--wp--preset--color--base);}.wp-container-content-9cfa9a5a{flex-grow:1;}.wp-container-core-group-is-layout-ce155fab{flex-direction:column;align-items:center;}
			/*# sourceURL=core-block-supports-inline-css */
		</style>
		<style id="wp-block-template-skip-link-inline-css">
			.skip-link.screen-reader-text {
			    border: 0;
			    clip-path: inset(50%);
			    height: 1px;
			    margin: -1px;
			    overflow: hidden;
			    padding: 0;
			    position: absolute !important;
			    width: 1px;
			    word-wrap: normal !important;
			}
			
			.skip-link.screen-reader-text:focus {
			    background-color: #eee;
			    clip-path: none;
			    color: #444;
			    display: block;
			    font-size: 1em;
			    height: auto;
			    left: 5px;
			    line-height: normal;
			    padding: 15px 23px 14px;
			    text-decoration: none;
			    top: 5px;
			    width: auto;
			    z-index: 100000;
			}
			/*# sourceURL=wp-block-template-skip-link-inline-css */</style>
		<style id="twentytwentyfive-style-inline-css">
			a{text-decoration-thickness:1px!important;text-underline-offset:.1em}:where(.wp-site-blocks :focus){outline-style:solid;outline-width:2px}.wp-block-navigation .wp-block-navigation-submenu .wp-block-navigation-item:not(:last-child){margin-bottom:3px}.wp-block-navigation .wp-block-navigation-item .wp-block-navigation-item__content{outline-offset:4px}.wp-block-navigation .wp-block-navigation-item ul.wp-block-navigation__submenu-container .wp-block-navigation-item__content{outline-offset:0}blockquote,caption,figcaption,h1,h2,h3,h4,h5,h6,p{text-wrap:pretty}.more-link{display:block}:where(pre){overflow-x:auto}
			/*# sourceURL=https://kerameikos.org/wp-content/themes/twentytwentyfive/style.min.css */
		</style>
		<link rel="https://api.w.org/" href="https://kerameikos.org/wp-json/"/>
		<link rel="alternate" title="JSON" type="application/json" href="https://kerameikos.org/wp-json/wp/v2/pages/121"/>
		<link rel="EditURI" type="application/rsd+xml" title="RSD" href="https://kerameikos.org/xmlrpc.php?rsd"/>
		<meta name="generator" content="WordPress 6.9.1"/>
		<link rel="canonical" href="https://kerameikos.org/meet-the-team/"/>
		<link rel="shortlink" href="https://kerameikos.org/?p=121"/>
		<script type="importmap" id="wp-importmap">
			{"imports":{"@wordpress/interactivity":"https://kerameikos.org/wp-includes/js/dist/script-modules/interactivity/index.min.js?ver=66c613f68580994bb00a"}}
		</script>
		<link rel="modulepreload" href="https://kerameikos.org/wp-includes/js/dist/script-modules/interactivity/index.min.js?ver=66c613f68580994bb00a"
			id="@wordpress/interactivity-js-modulepreload" fetchpriority="low"/>
		<style class="wp-fonts-local">
			@font-face {
			    font-family: Manrope;
			    font-style: normal;
			    font-weight: 200 800;
			    font-display: fallback;
			    src: url('https://kerameikos.org/wp-content/themes/twentytwentyfive/assets/fonts/manrope/Manrope-VariableFont_wght.woff2') format('woff2');
			}
			@font-face {
			    font-family: "Fira Code";
			    font-style: normal;
			    font-weight: 300 700;
			    font-display: fallback;
			    src: url('https://kerameikos.org/wp-content/themes/twentytwentyfive/assets/fonts/fira-code/FiraCode-VariableFont_wght.woff2') format('woff2');
			}</style>

		<script type="importmap" id="wp-importmap">
			{"imports":{"@wordpress/interactivity":"https://kerameikos.org/wp-includes/js/dist/script-modules/interactivity/index.min.js?ver=66c613f68580994bb00a"}}
		</script>
		<link rel="modulepreload" href="https://kerameikos.org/wp-includes/js/dist/script-modules/interactivity/index.min.js?ver=66c613f68580994bb00a"
			id="@wordpress/interactivity-js-modulepreload" fetchpriority="low"/>

		<script type="module" src="https://kerameikos.org/wp-includes/js/dist/script-modules/block-library/navigation/view.min.js?ver=b0f909c3ec791c383210" id="@wordpress/block-library/navigation/view-js-module" fetchpriority="low" data-wp-router-options="{$json3}"/>
		<script src="https://kerameikos.org/wp-includes/js/hoverintent-js.min.js?ver=2.2.1" id="hoverintent-js-js"/>
	</xsl:template>

</xsl:stylesheet>
